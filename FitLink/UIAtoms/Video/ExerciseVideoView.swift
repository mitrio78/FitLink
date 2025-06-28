import SwiftUI
import AVFoundation

struct ExerciseVideoView: View {
    let url: URL
    /// Stable ``AVPlayer`` instance. Created once in ``init`` so the backing
    /// ``AVPlayerLayer`` can render frames reliably.
    let player: AVPlayer

    @State private var isPlaying = true
    @State private var showFullScreen = false
    @State private var progress: Double = 0
    @State private var timeObserver: Any?
    @State private var endObserver: NSObjectProtocol?
    @State private var orientation: Orientation = .horizontal

    private enum Orientation { case vertical, horizontal }

    init(url: URL) {
        self.url = url
        self.player = AVPlayer(url: url)
    }

    var body: some View {
        VStack(spacing: Theme.spacing.small) {
            ZStack {
                CustomAVPlayerView(player: player)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius.image))
                    .onTapGesture { showFullScreen = true }
                    .aspectRatio(orientation == .vertical ? 9/16 : 16/9, contentMode: .fill)
                    .frame(maxWidth: .infinity)
            } //: ZStack

            HStack(spacing: Theme.spacing.small) {
                Button(action: togglePlayPause) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 28))
                }
                ProgressView(value: progress)
                    .frame(maxWidth: .infinity)
            } //: HStack
            .padding(.horizontal, Theme.spacing.medium)
        } //: VStack
        .onAppear { setupPlayer() }
        .onDisappear {
            player.pause()
            if let token = timeObserver {
                player.removeTimeObserver(token)
                timeObserver = nil
            }
            if let obs = endObserver {
                NotificationCenter.default.removeObserver(obs)
                endObserver = nil
            }
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenVideoView(url: url)
        }
    }

    private func setupPlayer() {
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
        detectOrientation(from: item.asset)
    }

    private func detectOrientation(from asset: AVAsset) {
        asset.loadValuesAsynchronously(forKeys: ["tracks"]) {
            var error: NSError?
            let status = asset.statusOfValue(forKey: "tracks", error: &error)
            guard status == .loaded,
                  let track = asset.tracks(withMediaType: .video).first else { return }
            let size = track.naturalSize.applying(track.preferredTransform)
            let vertical = abs(size.height) > abs(size.width)
            DispatchQueue.main.async {
                orientation = vertical ? .vertical : .horizontal
            }
        }
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
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            let duration = player.currentItem?.duration.seconds ?? 0
            guard duration.isFinite, duration > 0, time.seconds.isFinite else {
                progress = 0
                return
            }
            let value = time.seconds / duration
            progress = min(max(value, 0), 1)
        }
    }
}

#Preview {
    ExerciseVideoView(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
        .padding()
        .previewLayout(.sizeThatFits)
}
