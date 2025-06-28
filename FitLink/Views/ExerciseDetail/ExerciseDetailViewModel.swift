import Foundation
import Combine

@MainActor
final class ExerciseDetailViewModel: ObservableObject {
    @Published var exercise: Exercise
    @Published var showEdit: Bool = false
    @Published var fullScreenMediaURL: URL?

    private let dataStore: AppDataStore
    private let exerciseId: UUID
    private var cancellables: Set<AnyCancellable> = []

    init(exerciseId: UUID, dataStore: AppDataStore) {
        self.exerciseId = exerciseId
        self.dataStore = dataStore
        self.exercise = dataStore.exercises.first { $0.id == exerciseId }!

        dataStore.$exercises
            .compactMap { $0.first(where: { $0.id == exerciseId }) }
            .assign(to: &$exercise)
    }

    func editTapped() {
        showEdit = true
    }

    func mediaTapped() {
        fullScreenMediaURL = exercise.mediaURL
    }
}

