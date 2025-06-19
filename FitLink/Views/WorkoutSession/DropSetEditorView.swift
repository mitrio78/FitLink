import SwiftUI

/// Modal screen for editing drops within an approach
struct DropSetEditorView: View {
    var onComplete: ([ExerciseSet]) -> Void

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: DropSetEditorViewModel

    init(sets: [ExerciseSet], metrics: [ExerciseMetric], onComplete: @escaping ([ExerciseSet]) -> Void) {
        self.onComplete = onComplete
        _viewModel = StateObject(wrappedValue: DropSetEditorViewModel(sets: sets, metrics: metrics))
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.sets.indices, id: \.self) { idx in
                    SetEditorRow(set: $viewModel.sets[idx], metrics: viewModel.metrics, showLabels: false)
                        .listRowSeparator(.hidden)
                        .overlay(alignment: .topLeading) {
                            Text(label(for: idx))
                                .font(Theme.font.caption)
                                .foregroundColor(.secondary)
                        }
                }
                .onDelete(perform: viewModel.deleteDrops)

                Button(action: viewModel.addDrop) {
                    Image(systemName: "plus")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.color.backgroundSecondary)
                        .cornerRadius(Theme.radius.card)
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets(top: 0,
                                         leading: Theme.spacing.large,
                                         bottom: 0,
                                         trailing: Theme.spacing.large))
            }
            .listStyle(.plain)
            .simultaneousGesture(
                TapGesture().onEnded { _ in hideKeyboard() }
            )
            .navigationTitle(NSLocalizedString("DropEditor.Title", comment: "Edit Drops"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("Common.Cancel", comment: "Cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(NSLocalizedString("Common.Done", comment: "Done")) {
                        hideKeyboard()
                        onComplete(viewModel.sets)
                        dismiss()
                    }
                }
            }
        }
    }

    private func label(for index: Int) -> String {
        if index == 0 {
            return NSLocalizedString("DropSetView.MainStep", comment: "Basic")
        } else {
            return String(format: NSLocalizedString("DropSetView.DropStep", comment: "Drop %d"), index)
        }
    }
}

#Preview {
    let metrics = [ExerciseMetric(type: .weight, unit: .kilogram, isRequired: false),
                   ExerciseMetric(type: .reps, unit: .repetition, isRequired: true)]
    let first = ExerciseSet(id: UUID(), metricValues: [.weight: 50, .reps: 8])
    let drop = ExerciseSet(id: UUID(), metricValues: [.weight: 40, .reps: 8])
    return DropSetEditorView(sets: [first, drop], metrics: metrics) { _ in }
}
