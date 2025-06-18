import Foundation
import SwiftUI

struct EditingContext: Identifiable {
    let id: UUID
    let index: Int
    let instances: [ExerciseInstance]
    let group: SetGroup?

    var exercises: [Exercise] { instances.map { $0.exercise } }
}

@MainActor
final class WorkoutSessionViewModel: ObservableObject {
    @Published var showExerciseEdit: Bool = false
    @Published var editingContext: EditingContext? = nil
    let session: WorkoutSession
    let client: Client?

    @Published private(set) var exercises: [ExerciseInstance]
    @Published private(set) var setGroups: [SetGroup]

    init(session: WorkoutSession, client: Client?) {
        self.session = session
        self.client = client
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
        case .superset(let group, let instances):
            setGroups.append(group)
            exercises.append(contentsOf: instances)
        }
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
        }
    }

    func completeEdit(_ result: WorkoutExerciseEditResult) {
        if editingContext != nil {
            replaceItem(result)
        } else {
            addItem(result)
        }
        editingContext = nil
    }

    func deleteItem(withId id: UUID) {
        if let groupIndex = setGroups.firstIndex(where: { $0.id == id }) {
            let group = setGroups.remove(at: groupIndex)
            exercises.removeAll { group.exerciseInstanceIds.contains($0.id) }
        } else {
            exercises.removeAll { $0.id == id }
        }
    }
}
