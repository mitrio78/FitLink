import Foundation
import SwiftUI

struct EditingContext: Identifiable {
    let id: UUID
    let index: Int
    let instances: [ExerciseInstance]
    let group: SetGroup?

    var exercises: [Exercise] { instances.map { $0.exercise } }
}

struct SetEditContext: Identifiable {
    let exerciseID: UUID
    let setID: UUID
    let metrics: [ExerciseMetric]
    var values: [ExerciseMetric.ID: ExerciseMetricValue]

    var id: String { "\(exerciseID)-\(setID)" }
}

extension WorkoutSessionViewModel {
    /// Row representation used for displaying and reordering exercises.
    struct RowInfo: Identifiable {
        let id: String
        let exercise: ExerciseInstance
        let group: SetGroup?
        var groupExercises: [ExerciseInstance]
        /// Indicates if this row should be used when rebuilding the session.
        /// For supersets only the first row acts as the representative block.
        let isRepresentative: Bool
        let isFirstInGroup: Bool
        let isLastInGroup: Bool
    }
}

@MainActor
final class WorkoutSessionViewModel: ObservableObject {
    @Published var showExerciseEdit: Bool = false
    @Published var editingContext: EditingContext? = nil
    @Published var activeSetEdit: SetEditContext? = nil
    @Published var historyExercise: ExerciseInstance? = nil
    @Published var detailExercise: ExerciseInstance? = nil
    @Published var expandedGroupId: UUID? = nil
    @Published var session: WorkoutSession
    let client: Client?
    private let dataStore: AppDataStore

    @Published private(set) var exercises: [ExerciseInstance]
    @Published private(set) var setGroups: [SetGroup]

    init(session: WorkoutSession, client: Client?, dataStore: AppDataStore) {
        self.session = session
        self.client = client
        self.dataStore = dataStore
        self.exercises = session.exerciseInstances
        self.setGroups = session.setGroups ?? []
    }

    var warmUpExercises: [ExerciseInstance] {
        exercises.filter { $0.section == .warmUp }
    }

    var mainExercises: [ExerciseInstance] {
        exercises.filter { $0.section == .main }
    }

    var coolDownExercises: [ExerciseInstance] {
        exercises.filter { $0.section == .coolDown }
    }

    /// Returns visible rows for a particular workout section.
    func rows(for section: WorkoutSection) -> [RowInfo] {
        var result: [RowInfo] = []
        var seenGroups: Set<UUID> = []

        for ex in exercises where ex.section == section {
            if let group = group(for: ex) {
                if group.type == .superset {
                    let first = isFirstExerciseInGroup(ex)
                    let last = isLastExerciseInGroup(ex)
                    result.append(
                        RowInfo(id: rowKey(for: ex),
                                exercise: ex,
                                group: group,
                                groupExercises: groupExercises(for: group),
                                isRepresentative: first,
                                isFirstInGroup: first,
                                isLastInGroup: last)
                    )
                } else if !seenGroups.contains(group.id) {
                    seenGroups.insert(group.id)
                    result.append(
                        RowInfo(id: group.id.uuidString,
                                exercise: ex,
                                group: group,
                                groupExercises: groupExercises(for: group),
                                isRepresentative: true,
                                isFirstInGroup: true,
                                isLastInGroup: true)
                    )
                }
            } else {
                result.append(
                    RowInfo(id: ex.id.uuidString,
                            exercise: ex,
                            group: nil,
                            groupExercises: [ex],
                            isRepresentative: true,
                            isFirstInGroup: true,
                            isLastInGroup: true)
                )
            }
        }

        return result
    }

    /// Handles moving rows via drag & drop while keeping groups intact.
    func moveRow(fromOffsets offsets: IndexSet, toOffset destination: Int, in section: WorkoutSection) {
        var warmRows = rows(for: .warmUp)
        var mainRows = rows(for: .main)
        var coolRows = rows(for: .coolDown)

        func reorder(_ rows: inout [RowInfo]) {
            guard let start = offsets.first else { return }
            let groupId = rows[start].group?.id
            var moveIndexes = [start]
            if let gid = groupId {
                moveIndexes = rows.enumerated().compactMap { $0.element.group?.id == gid ? $0.offset : nil }
            }

            var adjustedDestination = destination
            if destination > moveIndexes.first! { adjustedDestination -= moveIndexes.count }
            rows.move(fromOffsets: IndexSet(moveIndexes), toOffset: adjustedDestination)
        }

        switch section {
        case .warmUp: reorder(&warmRows)
        case .main: reorder(&mainRows)
        case .coolDown: reorder(&coolRows)
        }

        rebuildRows(warm: warmRows, main: mainRows, cool: coolRows)
    }

    /// Persists the current order based on rows.
    private func rebuildRows(warm: [RowInfo], main: [RowInfo], cool: [RowInfo]) {
        var newExercises: [ExerciseInstance] = []
        var newGroups: [SetGroup] = []
        var added: Set<UUID> = []

        for row in warm + main + cool {
            if row.isRepresentative {
                newExercises.append(contentsOf: row.groupExercises)
                if let group = row.group, !added.contains(group.id) {
                    newGroups.append(group)
                    added.insert(group.id)
                }
            }
        }

        exercises = newExercises
        setGroups = newGroups
        save()
    }

    func addExerciseTapped() {
        editingContext = nil
        showExerciseEdit = true
    }

    func editSet(withID setId: UUID, ofExercise exerciseId: UUID) {
        guard let exerciseIndex = exercises.firstIndex(where: { $0.id == exerciseId }) else { return }
        let exercise = exercises[exerciseIndex]
        let metrics = exercise.exercise.metrics.sorted { metricOrder($0.type) < metricOrder($1.type) }
        for approach in exercise.approaches {
            if let set = approach.sets.first(where: { $0.id == setId }) {
                var values: [ExerciseMetric.ID: ExerciseMetricValue] = [:]
                for metric in metrics {
                    values[metric.id] = set.metricValues[metric.type] ?? (metric.type.requiresInteger ? .int(0) : .double(0))
                }
                activeSetEdit = SetEditContext(exerciseID: exerciseId, setID: setId, metrics: metrics, values: values)
                break
            }
        }
    }

    func addSet(toExercise exerciseId: UUID) {
        guard let exercise = exercises.first(where: { $0.id == exerciseId }) else { return }
        let metrics = exercise.exercise.metrics.sorted { metricOrder($0.type) < metricOrder($1.type) }
        var values: [ExerciseMetric.ID: ExerciseMetricValue] = [:]
        for metric in metrics {
            values[metric.id] = metric.type.requiresInteger ? .int(0) : .double(0)
        }
        activeSetEdit = SetEditContext(exerciseID: exerciseId, setID: UUID(), metrics: metrics, values: values)
    }

    func saveEditedSet() {
        guard let context = activeSetEdit else { return }
        guard let exIndex = exercises.firstIndex(where: { $0.id == context.exerciseID }) else { activeSetEdit = nil; return }
        var updated = false
        for aIndex in exercises[exIndex].approaches.indices {
            if let setIndex = exercises[exIndex].approaches[aIndex].sets.firstIndex(where: { $0.id == context.setID }) {
                for metric in context.metrics {
                    let val = context.values[metric.id] ?? (metric.type.requiresInteger ? .int(0) : .double(0))
                    exercises[exIndex].approaches[aIndex].sets[setIndex].metricValues[metric.type] = val
                }
                updated = true
                break
            }
        }

        if !updated {
            var metricValues: [ExerciseMetricType: ExerciseMetricValue] = [:]
            for metric in context.metrics {
                metricValues[metric.type] = context.values[metric.id] ?? (metric.type.requiresInteger ? .int(0) : .double(0))
            }
            let newSet = ExerciseSet(id: context.setID, metricValues: metricValues, notes: nil, drops: nil)
            exercises[exIndex].approaches.append(Approach(sets: [newSet]))
        }

        save()
        activeSetEdit = nil
    }

    // MARK: - Set Handling

    var headerTitle: String {
        guard let context = activeSetEdit else { return "" }
        let existing = label(for: context.setID, in: context.exerciseID)
        if !existing.isEmpty { return existing }

        if let exercise = exercises.first(where: { $0.id == context.exerciseID }) {
            return String(
                format: NSLocalizedString("CustomNumberPad.SetHeader", comment: "Set header"),
                exercise.approaches.count + 1
            )
        }
        return ""
    }

    /// Saves the current editing values and immediately inserts a new drop after the current one.
    func addNextSet() {
        guard let context = activeSetEdit else { return }
        guard let exIndex = exercises.firstIndex(where: { $0.id == context.exerciseID }) else { return }

        var approachIndex: Int? = nil
        var setIndex: Int? = nil

        // Save current set or create if not existing
        for aIndex in exercises[exIndex].approaches.indices {
            if let sIndex = exercises[exIndex].approaches[aIndex].sets.firstIndex(where: { $0.id == context.setID }) {
                for metric in context.metrics {
                    let val = context.values[metric.id] ?? (metric.type.requiresInteger ? .int(0) : .double(0))
                    exercises[exIndex].approaches[aIndex].sets[sIndex].metricValues[metric.type] = val
                }
                approachIndex = aIndex
                setIndex = sIndex
                break
            }
        }

        if approachIndex == nil || setIndex == nil {
            // Create a new approach with the current set if it was not found
            var metricValues: [ExerciseMetricType: ExerciseMetricValue] = [:]
            for metric in context.metrics {
                metricValues[metric.type] = context.values[metric.id] ?? (metric.type.requiresInteger ? .int(0) : .double(0))
            }
            let newSet = ExerciseSet(id: context.setID, metricValues: metricValues, notes: nil, drops: nil)
            exercises[exIndex].approaches.append(Approach(sets: [newSet]))
            approachIndex = exercises[exIndex].approaches.count - 1
            setIndex = 0
        }

        // Prepare new set values cloned from current
        var nextValues: [ExerciseMetricType: ExerciseMetricValue] = [:]
        for metric in context.metrics {
            nextValues[metric.type] = context.values[metric.id] ?? (metric.type.requiresInteger ? .int(0) : .double(0))
        }
        let newID = UUID()
        let newSet = ExerciseSet(id: newID, metricValues: nextValues, notes: nil, drops: nil)

        if let aIdx = approachIndex, let sIdx = setIndex {
            exercises[exIndex].approaches[aIdx].sets.insert(newSet, at: sIdx + 1)
        }
        save()

        var bindingValues: [ExerciseMetric.ID: ExerciseMetricValue] = [:]
        for metric in context.metrics {
            bindingValues[metric.id] = nextValues[metric.type]
        }
        activeSetEdit = SetEditContext(exerciseID: context.exerciseID, setID: newID, metrics: context.metrics, values: bindingValues)
    }

    /// Returns `true` if the current editing context corresponds to an existing set in the session.
    var canDeleteActiveSet: Bool {
        guard let context = activeSetEdit else { return false }
        return setExists(id: context.setID, inExercise: context.exerciseID)
    }

    /// Deletes the set currently being edited and dismisses the editor.
    func deleteActiveSet() {
        guard let context = activeSetEdit else { return }
        deleteSet(id: context.setID, fromExercise: context.exerciseID)
        activeSetEdit = nil
        save()
    }

    // MARK: - Private helpers

    private func setExists(id: UUID, inExercise exerciseID: UUID) -> Bool {
        guard let exercise = exercises.first(where: { $0.id == exerciseID }) else { return false }
        return exercise.approaches.contains { approach in
            approach.sets.contains(where: { $0.id == id })
        }
    }

    private func deleteSet(id setID: UUID, fromExercise exerciseID: UUID) {
        guard let exIndex = exercises.firstIndex(where: { $0.id == exerciseID }) else { return }
        for aIndex in exercises[exIndex].approaches.indices {
            if let sIndex = exercises[exIndex].approaches[aIndex].sets.firstIndex(where: { $0.id == setID }) {
                exercises[exIndex].approaches[aIndex].sets.remove(at: sIndex)
                if exercises[exIndex].approaches[aIndex].sets.isEmpty {
                    exercises[exIndex].approaches.remove(at: aIndex)
                }
                break
            }
        }
    }

    private func label(for setID: UUID, in exerciseID: UUID) -> String {
        guard let exercise = exercises.first(where: { $0.id == exerciseID }) else { return "" }
        for (approachIndex, approach) in exercise.approaches.enumerated() {
            if let dropIndex = approach.sets.firstIndex(where: { $0.id == setID }) {
                if dropIndex == 0 {
                    return String(format: NSLocalizedString("CustomNumberPad.SetHeader", comment: "Set header"), approachIndex + 1)
                } else {
                    return String(format: NSLocalizedString("CustomNumberPad.DropHeader", comment: "Drop header"), dropIndex)
                }
            }
        }
        return ""
    }

    func editItemTapped(withId id: UUID) {
        if let group = setGroups.first(where: { $0.id == id }) {
            let exercisesInGroup = groupExercises(for: group)
            if let first = exercisesInGroup.first,
               let index = exercises.firstIndex(where: { $0.id == first.id }) {
                editingContext = EditingContext(id: group.id,
                                               index: index,
                                               instances: exercisesInGroup,
                                               group: group)
                showExerciseEdit = true
            }
        } else if let index = exercises.firstIndex(where: { $0.id == id }) {
            let instance = exercises[index]
            editingContext = EditingContext(id: instance.id,
                                           index: index,
                                           instances: [instance],
                                           group: nil)
            showExerciseEdit = true
        }
    }

    func group(for exercise: ExerciseInstance) -> SetGroup? {
        setGroups.first { $0.exerciseInstanceIds.contains(exercise.id) }
    }

    func isFirstExerciseInGroup(_ exercise: ExerciseInstance) -> Bool {
        guard let group = group(for: exercise) else { return false }
        return group.exerciseInstanceIds.first == exercise.id
    }

    func isLastExerciseInGroup(_ exercise: ExerciseInstance) -> Bool {
        guard let group = group(for: exercise) else { return false }
        return group.exerciseInstanceIds.last == exercise.id
    }

    func groupExercises(for group: SetGroup) -> [ExerciseInstance] {
        exercises.filter { group.exerciseInstanceIds.contains($0.id) }
    }

    /// Returns a stable identifier for a row that also reflects
    /// whether the exercise sits at the top or bottom of its group.
    /// This helps List recreate cells when those positions change.
    func rowKey(for exercise: ExerciseInstance) -> String {
        let first = isFirstExerciseInGroup(exercise)
        let last = isLastExerciseInGroup(exercise)
        return "\(exercise.id.uuidString)-\(first)-\(last)"
    }

    func isExerciseInAnyGroup(_ exercise: ExerciseInstance) -> Bool {
        setGroups.contains(where: { $0.exerciseInstanceIds.contains(exercise.id) })
    }

    func addItem(_ result: WorkoutExerciseEditResult) {
        switch result {
        case .single(let instance):
            exercises.append(instance)
            expandedGroupId = nil
        case .superset(let group, let instances):
            setGroups.append(group)
            exercises.append(contentsOf: instances)
            expandedGroupId = group.id
        case .deleted:
            expandedGroupId = nil
        }
        save()
    }

    func replaceItem(_ result: WorkoutExerciseEditResult) {
        guard let context = editingContext else { return }

        // Determine insertion index before modifying arrays
        var insertionIndex = context.index

        if let group = context.group {
            if let idx = setGroups.firstIndex(where: { $0.id == group.id }) {
                setGroups.remove(at: idx)
            }
            exercises.removeAll { group.exerciseInstanceIds.contains($0.id) }
        } else {
            exercises.removeAll { $0.id == context.id }
        }

        if insertionIndex > exercises.count { insertionIndex = exercises.count }

        switch result {
        case .single(var instance):
            if let old = context.instances.first,
               old.exercise.metrics.map(\.type) == instance.exercise.metrics.map(\.type) {
                instance.approaches = old.approaches
                instance.notes = old.notes
            }
            instance.section = context.instances.first?.section ?? .main
            exercises.insert(instance, at: insertionIndex)
            expandedGroupId = nil
        case .superset(var group, var instances):
            if let oldGroup = context.group { group.notes = oldGroup.notes }
            for i in 0..<instances.count {
                var item = instances[i]
                if context.instances.indices.contains(i) {
                    let old = context.instances[i]
                    if old.exercise.metrics.map(\.type) == item.exercise.metrics.map(\.type) {
                        item.approaches = old.approaches
                        item.notes = old.notes
                    }
                    item.section = old.section
                }
                instances[i] = item
            }
            setGroups.append(group)
            exercises.insert(contentsOf: instances, at: insertionIndex)
            expandedGroupId = group.id
        case .deleted:
            // Handled outside this switch
            expandedGroupId = nil
        }
        save()
    }

    func completeEdit(_ result: WorkoutExerciseEditResult) {
        if editingContext != nil {
            if case .deleted = result {
                deleteItem(withId: editingContext!.id)
            } else {
                replaceItem(result)
            }
        } else if case .deleted = result {
            // nothing to delete
            return
        } else {
            addItem(result)
        }
        editingContext = nil
        save()
    }

    func deleteItem(withId id: UUID) {
        if let groupIndex = setGroups.firstIndex(where: { $0.id == id }) {
            let group = setGroups.remove(at: groupIndex)
            exercises.removeAll { group.exerciseInstanceIds.contains($0.id) }
        } else {
            exercises.removeAll { $0.id == id }
        }
        save()
    }

    func showHistory(for id: UUID) {
        historyExercise = exercises.first(where: { $0.id == id })
    }

    func showDetails(for id: UUID) {
        detailExercise = exercises.first(where: { $0.id == id })
    }

    func duplicateItem(withId id: UUID) {
        if let group = setGroups.first(where: { $0.id == id }) {
            let newGroupId = UUID()
            let newInstances: [ExerciseInstance] = group.exerciseInstanceIds.compactMap { exId in
                guard let instance = exercises.first(where: { $0.id == exId }) else { return nil }
                return duplicatedInstance(instance, newGroupId: newGroupId)
            }
            let newIds = newInstances.map(\.id)
            let newGroup = SetGroup(id: newGroupId, type: group.type, exerciseInstanceIds: newIds, repeatCount: group.repeatCount, notes: group.notes)

            if let lastIndex = group.exerciseInstanceIds.compactMap({ exId in exercises.firstIndex(where: { $0.id == exId }) }).max() {
                exercises.insert(contentsOf: newInstances, at: lastIndex + 1)
            } else {
                exercises.append(contentsOf: newInstances)
            }
            setGroups.append(newGroup)
        } else if let index = exercises.firstIndex(where: { $0.id == id }) {
            let instance = exercises[index]
            if let groupId = instance.groupId,
               let groupIndex = setGroups.firstIndex(where: { $0.id == groupId }) {
                var group = setGroups[groupIndex]
                if group.type == .superset {
                    // Duplicate as a standalone exercise placed after the entire superset
                    let copy = duplicatedInstance(instance, newGroupId: nil)
                    if let lastIndex = group.exerciseInstanceIds.compactMap({ exId in exercises.firstIndex(where: { $0.id == exId }) }).max() {
                        exercises.insert(copy, at: lastIndex + 1)
                    } else {
                        exercises.append(copy)
                    }
                } else {
                    // Duplicate inside the same group maintaining order
                    let copy = duplicatedInstance(instance, newGroupId: groupId)
                    exercises.insert(copy, at: index + 1)
                    if let pos = group.exerciseInstanceIds.firstIndex(of: id) {
                        group.exerciseInstanceIds.insert(copy.id, at: pos + 1)
                        setGroups[groupIndex] = group
                    }
                }
            } else {
                let copy = duplicatedInstance(instance, newGroupId: nil)
                exercises.insert(copy, at: index + 1)
            }
        }
        save()
    }

    /// Deletes a specific exercise from a superset. If the superset becomes
    /// empty after the deletion, the superset itself is removed.
    func deleteExercise(_ exerciseId: UUID, fromSuperset supersetId: UUID) {
        guard let groupIndex = setGroups.firstIndex(where: { $0.id == supersetId }) else {
            return
        }

        exercises.removeAll { $0.id == exerciseId }

        var updatedGroup = setGroups[groupIndex]
        updatedGroup.exerciseInstanceIds.removeAll { $0 == exerciseId }

        if updatedGroup.exerciseInstanceIds.isEmpty {
            setGroups.remove(at: groupIndex)
        } else {
            setGroups[groupIndex] = updatedGroup
        }

        save()
    }

    private func save() {
        session.exerciseInstances = exercises
        session.setGroups = setGroups
        dataStore.updateSession(session)
    }

    /// Creates a deep copy of the provided `ExerciseInstance` using fresh IDs
    /// for the instance itself and all of its nested sets. The group ID can be
    /// overridden when duplicating items that belong to a new group.
    private func duplicatedInstance(_ instance: ExerciseInstance, newGroupId: UUID?) -> ExerciseInstance {
        let approaches = instance.approaches.map { approach -> Approach in
            let sets = approach.sets.map { set -> ExerciseSet in
                let drops = set.drops?.map { drop in
                    ExerciseSet(id: UUID(), metricValues: drop.metricValues, notes: drop.notes, drops: drop.drops)
                }
                return ExerciseSet(id: UUID(), metricValues: set.metricValues, notes: set.notes, drops: drops)
            }
            return Approach(id: UUID(), sets: sets)
        }
        return ExerciseInstance(id: UUID(), exercise: instance.exercise, approaches: approaches, groupId: newGroupId, notes: instance.notes, section: instance.section)
    }

    private func metricOrder(_ type: ExerciseMetricType) -> Int {
        switch type {
        case .reps: return 0
        case .weight: return 1
        default: return 2
        }
    }
}
