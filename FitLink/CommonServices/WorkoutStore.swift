import Foundation
import SwiftUI

/// Simple in-memory store for workout sessions
final class WorkoutStore: ObservableObject {
    @Published var sessions: [WorkoutSession]

    init(sessions: [WorkoutSession] = MockData.complexMockSessions) {
        self.sessions = sessions
    }

    func session(with id: UUID) -> WorkoutSession? {
        sessions.first(where: { $0.id == id })
    }

    func addExercise(_ exercise: ExerciseInstance, to sessionId: UUID) {
        guard let idx = sessions.firstIndex(where: { $0.id == sessionId }) else { return }
        sessions[idx].exerciseInstances.append(exercise)
    }

    func updateExercise(_ exercise: ExerciseInstance, in sessionId: UUID) {
        guard let sIndex = sessions.firstIndex(where: { $0.id == sessionId }) else { return }
        guard let eIndex = sessions[sIndex].exerciseInstances.firstIndex(where: { $0.id == exercise.id }) else { return }
        sessions[sIndex].exerciseInstances[eIndex] = exercise
    }
}
