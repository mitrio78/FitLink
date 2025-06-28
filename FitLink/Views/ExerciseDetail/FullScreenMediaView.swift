import SwiftUI
import AVFoundation

struct FullScreenMediaView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: FullScreenMediaViewModel

    init(url: URL) {
        _viewModel = StateObject(wrappedValue: FullScreenMediaViewModel(url: url))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if viewModel.isVideo {
                VideoPlayerView(player: viewModel.player)
                    .onTapGesture { dismiss() }
            } else {
                AsyncImage(url: viewModel.url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    default:
                        Rectangle().fill(Color.black)
                    }
                }
                .onTapGesture { dismiss() }
            }
        }
        .onAppear { viewModel.start() }
        .onDisappear { viewModel.stop() }
    }
}

#if DEBUG
#Preview {
    FullScreenMediaView(url: URL(fileURLWithPath: "/dev/null"))
}
#endif
