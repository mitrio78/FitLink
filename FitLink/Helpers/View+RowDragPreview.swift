import SwiftUI

#if canImport(UIKit)
/// Compatibility helper to customize the preview shown when dragging rows.
/// Uses `listRowDragPreview` on iOS 17+ when compiled with an SDK that
/// exposes the API. Older toolchains simply ignore the preview and retain
/// the default behavior.
extension View {
    @ViewBuilder
    func rowDragPreview<Content: View>(@ViewBuilder _ preview: () -> Content) -> some View {
        if #available(iOS 17.0, *) {
            #if compiler(>=5.9)
            self.listRowDragPreview(preview())
            #else
            self
            #endif
        } else {
            self
        }
    }
}
#endif
