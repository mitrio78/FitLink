import Foundation
import SwiftUI

@MainActor
class AppDataStore: ObservableObject {
    static let shared = AppDataStore()

    @Published var clients: [Client]
    @Published var sessions: [WorkoutSession]
    @Published var exercises: [Exercise]

    private let mediaManager = ExerciseMediaManager.shared

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

    func saveExercise(_ exercise: Exercise) {
        if let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
            exercises[index] = exercise
            exercises = Array(exercises)
        } else {
            exercises.append(exercise)
        }
    }

    // MARK: - Media management

    /// Saves a media file for the given exercise from a temporary location.
    /// The resulting URL is stored on the exercise and returned.
    func saveMedia(for exercise: Exercise, from tempURL: URL) async throws -> URL {
        let url = try await mediaManager.saveMedia(for: exercise.id, from: tempURL)
        var updated = exercise
        updated.mediaURL = url
        saveExercise(updated)
        return url
    }

    /// Removes the media file associated with the exercise and clears its `mediaURL`.
    func removeMedia(for exercise: Exercise) async throws {
        try await mediaManager.removeMedia(for: exercise.id)
        var updated = exercise
        updated.mediaURL = nil
        saveExercise(updated)
    }

    /// Replaces an existing media file with a new one.
    func updateMedia(for exercise: Exercise, with tempURL: URL) async throws -> URL {
        let url = try await mediaManager.updateMedia(for: exercise.id, with: tempURL)
        var updated = exercise
        updated.mediaURL = url
        saveExercise(updated)
        return url
    }

    /// Deletes an exercise and its associated media file.
    func deleteExercise(_ exercise: Exercise) async throws {
        try await mediaManager.removeMedia(for: exercise.id)
        exercises.removeAll { $0.id == exercise.id }
        exercises = Array(exercises)
    }

    /// Removes media files that no longer have a corresponding exercise entry.
    func cleanupOrphanedMedia() async throws {
        let ids = Set(exercises.map { $0.id })
        try await mediaManager.cleanup(orphanedAgainst: ids)
    }

}
