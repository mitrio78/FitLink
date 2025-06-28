import Foundation
import AVFoundation

@MainActor
final class FullScreenMediaViewModel: ObservableObject {
    let url: URL
    let isVideo: Bool
    let player: AVQueuePlayer
    private var looper: AVPlayerLooper?

    init(url: URL) {
        self.url = url
        self.isVideo = url.isVideo
        self.player = AVQueuePlayer()
        if isVideo {
            let item = AVPlayerItem(url: url)
            self.looper = AVPlayerLooper(player: player, templateItem: item)
            player.actionAtItemEnd = .none
        }
    }

    func start() {
        if isVideo {
            player.play()
        }
    }

    func stop() {
        if isVideo {
            player.pause()
        }
    }
}
