import SwiftUI
import AVKit
import UniformTypeIdentifiers

struct FullScreenMediaView: View {
    let url: URL
    let isVideo: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if isVideo {
                LoopingVideoPlayer(url: url)
                    .ignoresSafeArea()
            } else {
                ZoomableAsyncImage(url: url)
            }
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .padding()
            }
        } //: ZStack
        .background(Color.black)
        .ignoresSafeArea()
    }
}

struct ZoomableAsyncImage: View {
    let url: URL
    @State private var scale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var lastScale: CGFloat = 1
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = lastScale * value
                            }
                            .onEnded { _ in
                                lastScale = scale
                            }
                    )
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { value in
                                offset = CGSize(width: lastOffset.width + value.translation.width,
                                                height: lastOffset.height + value.translation.height)
                            }
                            .onEnded { _ in
                                lastOffset = offset
                            }
                    )
                    .ignoresSafeArea()
            default:
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
}

struct LoopingVideoPlayer: UIViewRepresentable {
    let url: URL
    var autoplay: Bool = true
    var loop: Bool = true

    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.configure(url: url, autoplay: autoplay, loop: loop)
        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) {}

    final class PlayerView: UIView {
        private var player: AVQueuePlayer?
        private var looper: AVPlayerLooper?
        private var playerLayer: AVPlayerLayer?

        func configure(url: URL, autoplay: Bool, loop: Bool) {
            let item = AVPlayerItem(url: url)
            let queue = AVQueuePlayer(playerItem: item)
            player = queue
            if loop {
                looper = AVPlayerLooper(player: queue, templateItem: item)
            }
            let layer = AVPlayerLayer(player: queue)
            layer.videoGravity = .resizeAspectFill
            layer.frame = bounds
            self.layer.addSublayer(layer)
            playerLayer = layer
            if autoplay {
                queue.play()
            }
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            playerLayer?.frame = bounds
        }

        deinit {
            player?.pause()
            player = nil
            looper = nil
        }
    }
}

#Preview {
    FullScreenMediaView(url: URL(string: "https://example.com/video.mp4")!, isVideo: true)
}
