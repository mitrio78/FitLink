import SwiftUI

#if canImport(UIKit)
/// Compatibility helper to customize the preview shown when dragging rows.
/// Uses `listRowDragPreview` on iOS 17+ and falls back to the default
/// behavior on earlier OS versions.
extension View {
    @ViewBuilder
    func rowDragPreview<Content: View>(@ViewBuilder _ preview: () -> Content) -> some View {
        if #available(iOS 17.0, *) {
            self.listRowDragPreview(preview())
        } else {
            self
        }
    }
}
#endif
