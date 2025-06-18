import Foundation
import SwiftUI

@MainActor
final class WorkoutSessionViewModel: ObservableObject {
    @Published var showExerciseEdit: Bool = false
    let session: WorkoutSession
    let client: Client?

    init(session: WorkoutSession, client: Client?) {
        self.session = session
        self.client = client
    }

    var warmUpExercises: [ExerciseInstance] {
        session.exerciseInstances.filter { $0.section == .warmUp }
    }

    var mainExercises: [ExerciseInstance] {
        session.exerciseInstances.filter { $0.section == .main }
    }

    var coolDownExercises: [ExerciseInstance] {
        session.exerciseInstances.filter { $0.section == .coolDown }
    }

    func addExerciseTapped() {
        showExerciseEdit = true
    }

    func group(for exercise: ExerciseInstance) -> SetGroup? {
        session.setGroups?.first { $0.exerciseInstanceIds.contains(exercise.id) }
    }

    func isFirstExerciseInGroup(_ exercise: ExerciseInstance) -> Bool {
        guard let group = group(for: exercise) else { return false }
        return group.exerciseInstanceIds.first == exercise.id
    }

    func groupExercises(for group: SetGroup) -> [ExerciseInstance] {
        session.exerciseInstances.filter { group.exerciseInstanceIds.contains($0.id) }
    }

    func isExerciseInAnyGroup(_ exercise: ExerciseInstance) -> Bool {
        session.setGroups?.contains(where: { $0.exerciseInstanceIds.contains(exercise.id) }) ?? false
    }
}
