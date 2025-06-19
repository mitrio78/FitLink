import Foundation
import SwiftUI

@MainActor
final class AppDataStore: ObservableObject {
    static let shared = AppDataStore()

    @Published var clients: [Client]
    @Published var sessions: [WorkoutSession]
    @Published var exercises: [Exercise]

    var clientsById: [UUID: Client] {
        Dictionary(uniqueKeysWithValues: clients.map { ($0.id, $0) })
    }

    init(clients: [Client] = clientsMock,
         sessions: [WorkoutSession] = MockData.complexMockSessions,
         exercises: [Exercise] = exercisesCatalog) {
        self.clients = clients
        self.sessions = sessions
        self.exercises = exercises
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

    func updateSession(_ session: WorkoutSession) {
        guard let index = sessions.firstIndex(where: { $0.id == session.id }) else { return }
        sessions[index] = session
    }
}
