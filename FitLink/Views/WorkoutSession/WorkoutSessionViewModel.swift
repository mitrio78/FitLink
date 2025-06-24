import Foundation
import SwiftUI

struct EditingContext: Identifiable {
    let id: UUID
    let index: Int
    let instances: [ExerciseInstance]
    let group: SetGroup?

    var exercises: [Exercise] { instances.map { $0.exercise } }
}

struct MetricEditContext: Identifiable {
    let exerciseID: UUID
    let setID: UUID
    let metric: ExerciseMetric
    var currentValue: Double
    let unit: UnitType

    var id: String { "\(exerciseID)-\(setID)-\(metric.type)" }
}

@MainActor
final class WorkoutSessionViewModel: ObservableObject {
    @Published var showExerciseEdit: Bool = false
    @Published var editingContext: EditingContext? = nil
    @Published var activeMetricEdit: MetricEditContext? = nil
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

    func edit(metric: ExerciseMetric, forSet setId: UUID, ofExercise exerciseId: UUID) {
        guard let exerciseIndex = exercises.firstIndex(where: { $0.id == exerciseId }) else { return }
        let exercise = exercises[exerciseIndex]
        for approach in exercise.approaches {
            if let set = approach.sets.first(where: { $0.id == setId }) {
                let value = set.metricValues[metric.type] ?? 0
                let unit = metric.unit ?? .repetition
                activeMetricEdit = MetricEditContext(exerciseID: exerciseId,
                                                    setID: setId,
                                                    metric: metric,
                                                    currentValue: value,
                                                    unit: unit)
                break
            }
        }
    }

    func saveEditedMetric() {
        guard let context = activeMetricEdit else { return }
        guard let exIndex = exercises.firstIndex(where: { $0.id == context.exerciseID }) else { activeMetricEdit = nil; return }
        for aIndex in exercises[exIndex].approaches.indices {
            if let setIndex = exercises[exIndex].approaches[aIndex].sets.firstIndex(where: { $0.id == context.setID }) {
                if context.currentValue == 0 {
                    exercises[exIndex].approaches[aIndex].sets[setIndex].metricValues.removeValue(forKey: context.metric.type)
                } else {
                    exercises[exIndex].approaches[aIndex].sets[setIndex].metricValues[context.metric.type] = context.currentValue
                }
                save()
                break
            }
        }
        activeMetricEdit = nil
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
}
