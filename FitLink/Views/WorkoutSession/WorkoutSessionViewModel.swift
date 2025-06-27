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

@MainActor
final class WorkoutSessionViewModel: ObservableObject {
    @Published var showExerciseEdit: Bool = false
    @Published var editingContext: EditingContext? = nil
    @Published var activeSetEdit: SetEditContext? = nil
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

    // MARK: - Drop Handling

    var headerTitle: String {
        guard let context = activeSetEdit else { return "" }
        return label(for: context.setID, in: context.exerciseID)
    }

    func addDropStep() {
        guard let context = activeSetEdit else { return }
        guard let exIndex = exercises.firstIndex(where: { $0.id == context.exerciseID }) else { return }

        for aIndex in exercises[exIndex].approaches.indices {
            if let setIndex = exercises[exIndex].approaches[aIndex].sets.firstIndex(where: { $0.id == context.setID }) {
                var metricValues: [ExerciseMetricType: ExerciseMetricValue] = [:]
                for metric in context.metrics {
                    metricValues[metric.type] = context.values[metric.id] ?? (metric.type.requiresInteger ? .int(0) : .double(0))
                }
                let newSet = ExerciseSet(id: UUID(), metricValues: metricValues, notes: nil, drops: nil)
                exercises[exIndex].approaches[aIndex].sets.insert(newSet, at: setIndex + 1)
                save()
                var newValues: [ExerciseMetric.ID: ExerciseMetricValue] = [:]
                for metric in context.metrics {
                    newValues[metric.id] = metricValues[metric.type]
                }
                activeSetEdit = SetEditContext(exerciseID: context.exerciseID, setID: newSet.id, metrics: context.metrics, values: newValues)
                break
            }
        }
    }

    private func label(for setID: UUID, in exerciseID: UUID) -> String {
        guard let exercise = exercises.first(where: { $0.id == exerciseID }) else { return "" }
        for approach in exercise.approaches {
            if let index = approach.sets.firstIndex(where: { $0.id == setID }) {
                if index == 0 {
                    return NSLocalizedString("CustomNumberPad.MainHeader", comment: "Main set")
                } else {
                    return String(format: NSLocalizedString("CustomNumberPad.DropHeader", comment: "Drop header"), index)
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

    private func save() {
        session.exerciseInstances = exercises
        session.setGroups = setGroups
        dataStore.updateSession(session)
    }

    private func metricOrder(_ type: ExerciseMetricType) -> Int {
        switch type {
        case .reps: return 0
        case .weight: return 1
        default: return 2
        }
    }
}
