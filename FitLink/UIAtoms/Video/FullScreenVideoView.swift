import SwiftUI
import AVFoundation

struct FullScreenVideoView: View {
    @ObservedObject var holder: VideoPlayerHolder
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Color.black
            .ignoresSafeArea()
            .overlay(
                CustomAVPlayerView(player: holder.player)
                    .aspectRatio(holder.aspectRatio, contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            .onTapGesture { dismiss() }
            .onAppear { holder.setup() }
    }

}

#Preview {
    FullScreenVideoView(holder: VideoPlayerHolder(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!))
}
