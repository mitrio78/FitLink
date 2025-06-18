import SwiftUI

/// Screen to edit approaches (sets) for a single exercise
struct MetricEditorView: View {
    var onComplete: ([Approach]) -> Void

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: MetricEditorViewModel

    init(exercise: ExerciseInstance, onComplete: @escaping ([Approach]) -> Void) {
        self.onComplete = onComplete
        _viewModel = StateObject(wrappedValue: MetricEditorViewModel(approaches: exercise.approaches,
                                                                     metrics: exercise.exercise.metrics))
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(viewModel.approaches.enumerated()), id: \.offset) { idx, approach in
                    VStack(alignment: .leading) {
                        Text(String(format: NSLocalizedString("ApproachSetView.Title", comment: "Approach %d:"), idx + 1))
                            .font(Theme.font.body.bold())
                        SetEditorRow(set: binding(for: idx), metrics: viewModel.metrics)
                    }
                    .padding(.vertical, Theme.spacing.small)
                }
                .onDelete(perform: viewModel.removeApproach)

                Button(action: viewModel.addApproach) {
                    HStack {
                        Spacer()
                        Image(systemName: "plus")
                        Text(NSLocalizedString("WorkoutExerciseEdit.AddSet", comment: "Add Set"))
                        Spacer()
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(NSLocalizedString("MetricEditor.Title", comment: "Edit Sets"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("Common.Cancel", comment: "Cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(NSLocalizedString("Common.Done", comment: "Done")) {
                        onComplete(viewModel.approaches)
                        dismiss()
                    }
                }
            }
        }
    }

    private func binding(for index: Int) -> Binding<ExerciseSet> {
        Binding<ExerciseSet>(
            get: { viewModel.approaches[index].sets.first ?? ExerciseSet(id: UUID(), metricValues: [:], notes: nil, drops: nil) },
            set: { viewModel.approaches[index].sets = [$0] }
        )
    }
}

private struct SetEditorRow: View {
    @Binding var set: ExerciseSet
    let metrics: [ExerciseMetric]

    private let numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 2
        return f
    }()

    var body: some View {
        ForEach(metrics, id: \.type) { metric in
            HStack {
                Text(metric.displayName)
                Spacer()
                TextField("0", value: binding(for: metric.type), formatter: numberFormatter)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.primary)
            }
        }
    }

    private func binding(for type: ExerciseMetricType) -> Binding<Double> {
        Binding<Double>(
            get: { set.metricValues[type] ?? 0 },
            set: { set.metricValues[type] = $0 }
        )
    }
}

#Preview {
    let session = MockData.complexMockSessions.first!
    let instance = session.exerciseInstances.first!
    return MetricEditorView(exercise: instance) { _ in }
}
