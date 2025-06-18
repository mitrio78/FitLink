import SwiftUI

final class WorkoutSessionViewModel: ObservableObject {
    @Published var session: WorkoutSession

    init(session: WorkoutSession) {
        self.session = session
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

    func deleteExercise(withId id: UUID) {
        session.exerciseInstances.removeAll { $0.id == id }
        if var groups = session.setGroups {
            for index in groups.indices {
                groups[index].exerciseInstanceIds.removeAll { $0 == id }
            }
            session.setGroups = groups.filter { !$0.exerciseInstanceIds.isEmpty }
        }
    }
}
