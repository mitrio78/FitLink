import SwiftUI
import AVFoundation

struct FullScreenVideoView: View {
    let url: URL
    @Environment(\.dismiss) private var dismiss
    @StateObject private var holder: VideoPlayerHolder

    init(url: URL) {
        self.url = url
        _holder = StateObject(wrappedValue: VideoPlayerHolder(url: url))
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.edgesIgnoringSafeArea(.all)
            CustomAVPlayerView(player: holder.player)
                .onTapGesture { holder.togglePlayPause() }
                .onAppear { holder.setup() }
                .onDisappear { holder.cleanup() }
                .aspectRatio(holder.orientation == .vertical ? 9/16 : 16/9, contentMode: .fill)
                .frame(maxWidth: .infinity)
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .padding()
            }
        } //: ZStack
    }

}

#Preview {
    FullScreenVideoView(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
}
