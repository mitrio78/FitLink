import SwiftUI
import AVFoundation

struct ExerciseVideoView: View {
    let url: URL
    @State private var isPlaying = true
    @State private var showFullScreen = false
    @State private var player = AVPlayer()
    @State private var progress: Double = 0
    @State private var timeObserver: Any?

    var body: some View {
        VStack(spacing: Theme.spacing.small) {
            ZStack {
                CustomAVPlayerView(player: player)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius.image))
                    .onTapGesture { showFullScreen = true }
                    .frame(maxWidth: .infinity, maxHeight: 220)
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
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenVideoView(url: url)
        }
    }

    private func setupPlayer() {
        let item = AVPlayerItem(url: url)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: item, queue: .main) { _ in
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
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            if let duration = player.currentItem?.duration.seconds, duration > 0 {
                progress = time.seconds / duration
            }
        }
    }
}

#Preview {
    ExerciseVideoView(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
        .padding()
        .previewLayout(.sizeThatFits)
}
