import SwiftUI
import AVFoundation

/// Holder class keeping a stable ``AVPlayer`` instance and related observers.
final class VideoPlayerHolder: ObservableObject {
    enum Orientation { case vertical, horizontal }

    let url: URL
    let player: AVPlayer

    @Published var isPlaying: Bool = true
    @Published var progress: Double = 0
    @Published var orientation: Orientation = .horizontal

    private var timeObserver: Any?
    private var endObserver: NSObjectProtocol?

    init(url: URL) {
        self.url = url
        self.player = AVPlayer(url: url)
    }

    /// Configure the player once on appear. Subsequent calls simply resume playback.
    func setup() {
        guard player.currentItem == nil else {
            player.play()
            isPlaying = true
            return
        }

        let item = AVPlayerItem(url: url)
        endObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: item, queue: .main) { [weak self] _ in
            guard let self else { return }
            self.player.seek(to: .zero)
            self.player.play()
        }
        player.replaceCurrentItem(with: item)
        player.actionAtItemEnd = .none
        player.play()
        isPlaying = true
        addProgressObserver()
        detectOrientation(from: item.asset)
    }

    func togglePlayPause() {
        if isPlaying { player.pause() } else { player.play() }
        isPlaying.toggle()
    }

    private func addProgressObserver() {
        guard timeObserver == nil else { return }
        let interval = CMTime(seconds: 0.2, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self else { return }
            let duration = self.player.currentItem?.duration.seconds ?? 0
            guard duration.isFinite, duration > 0, time.seconds.isFinite else {
                self.progress = 0
                return
            }
            let value = time.seconds / duration
            self.progress = min(max(value, 0), 1)
        }
    }

    private func detectOrientation(from asset: AVAsset) {
        asset.loadValuesAsynchronously(forKeys: ["tracks"]) { [weak self] in
            guard let self else { return }
            var error: NSError?
            let status = asset.statusOfValue(forKey: "tracks", error: &error)
            guard status == .loaded,
                  let track = asset.tracks(withMediaType: .video).first else { return }
            let size = track.naturalSize.applying(track.preferredTransform)
            let vertical = abs(size.height) > abs(size.width)
            DispatchQueue.main.async {
                self.orientation = vertical ? .vertical : .horizontal
            }
        }
    }

    func cleanup() {
        if let token = timeObserver {
            player.removeTimeObserver(token)
            timeObserver = nil
        }
        if let obs = endObserver {
            NotificationCenter.default.removeObserver(obs)
            endObserver = nil
        }
        player.pause()
    }
}

struct ExerciseVideoView: View {
    let url: URL
    @StateObject private var holder: VideoPlayerHolder
    @State private var showFullScreen = false

    init(url: URL) {
        self.url = url
        _holder = StateObject(wrappedValue: VideoPlayerHolder(url: url))
    }

    var body: some View {
        VStack(spacing: Theme.spacing.small) {
            ZStack {
                CustomAVPlayerView(player: holder.player)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius.image))
                    .onTapGesture { showFullScreen = true }
                    .aspectRatio(holder.orientation == .vertical ? 9/16 : 16/9, contentMode: .fill)
                    .frame(maxWidth: .infinity)
            } //: ZStack

            HStack(spacing: Theme.spacing.small) {
                Button(action: { holder.togglePlayPause() }) {
                    Image(systemName: holder.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 28))
                }
                ProgressView(value: holder.progress)
                    .frame(maxWidth: .infinity)
            } //: HStack
            .padding(.horizontal, Theme.spacing.medium)
        } //: VStack
        .onAppear { holder.setup() }
        .onDisappear { holder.cleanup() }
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenVideoView(url: url)
        }
    }

}

#Preview {
    ExerciseVideoView(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
        .padding()
        .previewLayout(.sizeThatFits)
}
