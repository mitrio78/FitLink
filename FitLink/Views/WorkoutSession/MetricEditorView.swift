import SwiftUI

/// Screen to edit approaches (sets) for a single exercise
struct MetricEditorView: View {
    var onComplete: ([Approach]) -> Void
    private let scrollToIndex: Int?

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: MetricEditorViewModel

    init(exercise: ExerciseInstance, scrollToIndex: Int? = nil, onComplete: @escaping ([Approach]) -> Void) {
        self.onComplete = onComplete
        self.scrollToIndex = scrollToIndex
        _viewModel = StateObject(wrappedValue: MetricEditorViewModel(approaches: exercise.approaches,
                                                                     metrics: exercise.exercise.metrics))
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
            List {
                ForEach(Array(viewModel.approaches.enumerated()), id: \.offset) { idx, approach in
                    VStack(alignment: .leading, spacing: Theme.spacing.small) {
                        HStack(spacing: Theme.spacing.small) {
                            ApproachCardView(set: approachSet(from: approach), metrics: viewModel.metrics)
                                .frame(height: 64)
                            Button(action: { viewModel.editDrops(for: idx) }) {
                                Image(systemName: "plus")
                                    .frame(width: 64, height: 64)
                                    .foregroundColor(.primary)
                                    .background(Theme.color.backgroundSecondary)
                                    .cornerRadius(Theme.radius.card)
                            }
                            .buttonStyle(.plain)
                        }
                        SetEditorRow(set: binding(for: idx), metrics: viewModel.metrics)
                    }
                    .padding(.vertical, Theme.spacing.small)
                    .id(idx)
                }
                .onDelete(perform: viewModel.removeApproach)

                Button(action: viewModel.addApproach) {
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
            .navigationTitle(NSLocalizedString("MetricEditor.Title", comment: "Edit Sets"))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let idx = scrollToIndex {
                    DispatchQueue.main.async {
                        proxy.scrollTo(idx, anchor: .top)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("Common.Cancel", comment: "Cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(NSLocalizedString("Common.Done", comment: "Done")) {
                        hideKeyboard()
                        onComplete(viewModel.approaches)
                        dismiss()
                    }
                }
            }
            .sheet(item: $viewModel.dropEditContext) { context in
                DropSetEditorView(sets: viewModel.approaches[context.index].sets,
                                  metrics: viewModel.metrics) { sets in
                    viewModel.updateDrops(at: context.index, sets: sets)
                }
            }
            }
        }
    }

    private func binding(for index: Int) -> Binding<ExerciseSet> {
        Binding<ExerciseSet>(
            get: { viewModel.approaches[index].sets.first ?? ExerciseSet(id: UUID(), metricValues: [:], notes: nil, drops: nil) },
            set: { newValue in
                var sets = viewModel.approaches[index].sets
                if sets.isEmpty {
                    sets = [newValue]
                } else {
                    sets[0] = newValue
                }
                viewModel.approaches[index].sets = sets
            }
        )
    }

    private func approachSet(from approach: Approach) -> ExerciseSet {
        var first = approach.sets.first ?? ExerciseSet(id: UUID(), metricValues: [:], notes: nil, drops: nil)
        first.drops = Array(approach.sets.dropFirst())
        return first
    }
}
#Preview {
    let session = MockData.complexMockSessions.first!
    let instance = session.exerciseInstances.first!
    return MetricEditorView(exercise: instance, scrollToIndex: 0) { _ in }
}
