import SwiftUI
import UniformTypeIdentifiers

/// A stack that supports drag-and-drop reordering with custom drag previews.
struct ReorderableSectionView<Row: Identifiable, RowView: View, Preview: View>: View {
    var rows: [Row]
    var canDrag: (Row) -> Bool
    var onMove: (IndexSet, Int) -> Void
    var rowView: (Row) -> RowView
    var preview: (Row) -> Preview

    @State private var draggingID: Row.ID?

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(zip(rows.indices, rows)), id: \.1.id) { index, row in
                rowView(row)
                    .opacity(draggingID == row.id ? 0.5 : 1)
                    .background(
                        DragHandlers(
                            row: row,
                            index: index,
                            rows: rows,
                            canDrag: canDrag,
                            preview: preview,
                            onMove: onMove,
                            draggingID: $draggingID
                        )
                    )
            }
        }
    }

    private struct DragHandlers: View {
        let row: Row
        let index: Int
        let rows: [Row]
        let canDrag: (Row) -> Bool
        let preview: (Row) -> Preview
        let onMove: (IndexSet, Int) -> Void
        @Binding var draggingID: Row.ID?

        var body: some View {
            Color.clear
                .if(canDrag(row)) { view in
                    if #available(iOS 17.0, *) {
                        view.draggable(row.id, preview: { preview(row) })
                    } else {
                        view.onDrag {
                            draggingID = row.id
                            return NSItemProvider(object: NSString(string: String(describing: row.id)))
                        }
                    }
                }
                .onDrop(of: [UTType.text], delegate: DropDelegateImpl(row: row, rows: rows, onMove: onMove, draggingID: $draggingID))
        }
    }

    private struct DropDelegateImpl: DropDelegate {
        let row: Row
        let rows: [Row]
        let onMove: (IndexSet, Int) -> Void
        @Binding var draggingID: Row.ID?

        func dropEntered(info: DropInfo) {
            guard let source = draggingID,
                  source != row.id,
                  let fromIndex = rows.firstIndex(where: { $0.id == source }),
                  let toIndex = rows.firstIndex(where: { $0.id == row.id }) else { return }

            let dest = toIndex > fromIndex ? toIndex + 1 : toIndex
            onMove(IndexSet(integer: fromIndex), dest)
            draggingID = row.id
        }

        func performDrop(info: DropInfo) -> Bool {
            draggingID = nil
            return true
        }
    }
}

private extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition { transform(self) } else { self }
    }
}
