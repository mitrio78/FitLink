import SwiftUI
import AVFoundation

struct FullScreenVideoView: View {
    let url: URL
    /// Player used for full screen playback. Created once so the layer doesn't
    /// lose its connection during presentation changes.
    let player: AVPlayer
    @Environment(\.dismiss) private var dismiss
    @State private var isPlaying = true
    @State private var timeObserver: Any?
    @State private var endObserver: NSObjectProtocol?

    init(url: URL) {
        self.url = url
        self.player = AVPlayer(url: url)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.edgesIgnoringSafeArea(.all)
            CustomAVPlayerView(player: player)
                .onTapGesture { togglePlayPause() }
                .onAppear { setup() }
                .onDisappear { cleanup() }
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .padding()
            }
        } //: ZStack
    }

    private func setup() {
        guard player.currentItem == nil else { return }
        let item = AVPlayerItem(url: url)
        endObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: item, queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }
        player.replaceCurrentItem(with: item)
        player.actionAtItemEnd = .none
        player.play()
        isPlaying = true
        addProgressObserver()
    }

    private func togglePlayPause() {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }

    private func addProgressObserver() {
        let interval = CMTime(seconds: 0.2, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { _ in }
    }

    private func cleanup() {
        if let token = timeObserver {
            player.removeTimeObserver(token)
            timeObserver = nil
        }
        if let obs = endObserver {
            NotificationCenter.default.removeObserver(obs)
            endObserver = nil
        }
    }
}

#Preview {
    FullScreenVideoView(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
}
