import SwiftUI
import AVFoundation
import UIKit

/// SwiftUI wrapper around ``AVPlayerLayer`` that keeps the supplied ``AVPlayer``
/// instance attached to the layer. The player reference must remain stable for
/// the video frames to render correctly.
struct CustomAVPlayerView: UIViewRepresentable {
    /// Stable player instance driving the layer.
    let player: AVPlayer

    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        // Use resizeAspect so the entire frame is visible without cropping
        view.playerLayer.videoGravity = .resizeAspect
        view.player = player
        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) {
        // Update player only when the instance actually changes.
        if uiView.player !== player {
            uiView.player = player
        }
    }
}

final class PlayerView: UIView {
    override class var layerClass: AnyClass { AVPlayerLayer.self }

    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }

    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
