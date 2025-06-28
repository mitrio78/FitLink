import Foundation
import Combine
import AVFoundation

@MainActor
final class ExerciseDetailViewModel: ObservableObject {
    @Published var exercise: Exercise
    @Published var showEdit: Bool = false
    @Published var fullScreenMediaURL: URL?
    @Published private(set) var previewPlayer: AVPlayer?

    private let dataStore: AppDataStore
    private let exerciseId: UUID
    private var cancellables: Set<AnyCancellable> = []

    init(exerciseId: UUID, dataStore: AppDataStore) {
        self.exerciseId = exerciseId
        self.dataStore = dataStore
        self.exercise = dataStore.exercises.first { $0.id == exerciseId }!
        self.setupPreviewPlayer(with: exercise.mediaURL)

        dataStore.$exercises
            .compactMap { $0.first(where: { $0.id == exerciseId }) }
            .sink { [weak self] updated in
                guard let self else { return }
                self.exercise = updated
                self.setupPreviewPlayer(with: updated.mediaURL)
            }
            .store(in: &cancellables)
    }

    func editTapped() {
        showEdit = true
    }

    func mediaTapped() {
        fullScreenMediaURL = exercise.mediaURL
    }

    private func setupPreviewPlayer(with url: URL?) {
        guard let url = url, url.isVideo else {
            previewPlayer = nil
            return
        }

        if let player = previewPlayer,
           let assetURL = (player.currentItem?.asset as? AVURLAsset)?.url,
           assetURL == url {
            return
        }

        let player = previewPlayer ?? AVPlayer()
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        player.actionAtItemEnd = .pause
        player.seek(to: .zero)
        previewPlayer = player
    }
}

