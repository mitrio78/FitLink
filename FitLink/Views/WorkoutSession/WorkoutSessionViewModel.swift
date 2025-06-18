import Foundation
import SwiftUI

@MainActor
final class WorkoutSessionViewModel: ObservableObject {
    @Published var showExerciseEdit: Bool = false
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
        showExerciseEdit = true
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

    func deleteExercise(withId id: UUID) {
        if let groupIndex = setGroups.firstIndex(where: { $0.exerciseInstanceIds.contains(id) }) {
            let ids = setGroups[groupIndex].exerciseInstanceIds
            exercises.removeAll { ids.contains($0.id) }
            setGroups.remove(at: groupIndex)
        } else {
            exercises.removeAll { $0.id == id }
        }
    }
}
