import SwiftUI

/// Horizontally scrollable list of exercise approaches.
struct ApproachListView: View {
    let sets: [ExerciseSet]
    let metrics: [ExerciseMetric]
    var onSetTap: (ExerciseSet.ID) -> Void = { _ in }
    var onAddTap: () -> Void = {}
    var isLocked: Bool = false


    var body: some View {
        let innerSpacing = Theme.current.layoutMode == .compact ? Theme.current.spacing.compactMetricSpacing : Theme.spacing.small
        let verticalPadding = Theme.current.layoutMode == .compact ? Theme.current.spacing.compactSetRowSpacing : Theme.spacing.small
        let rows = [GridItem(.flexible(), spacing: innerSpacing, alignment: .top)]
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: innerSpacing) {
                ForEach(sets) { set in
                    ApproachCardView(set: set, metrics: metrics) { id in
                        onSetTap(id)
                    }
                }
                if !isLocked {
                    AddSetButton(action: onAddTap)
                }
            }
        } //: ScrollView
        .padding(.vertical, verticalPadding)
        .fixedSize(horizontal: false, vertical: true)
    }
}

private struct AddSetButton: View {
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(Theme.current.layoutMode == .compact ? Theme.font.compactMetricValue : Theme.font.metrics1)
        } //: Button
        .metricCardStyle()
        .frame(maxHeight: .infinity)
        .buttonStyle(ScaleButtonStyle())
        .foregroundColor(.secondary)
        .accessibilityLabel(NSLocalizedString("WorkoutExerciseEdit.AddSet", comment: "Add Set"))
    }
}

private struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

#Preview {
    let metrics = [ExerciseMetric(type: .reps, unit: .repetition, isRequired: true),
                   ExerciseMetric(type: .weight, unit: .kilogram, isRequired: false)]
    let set1 = ExerciseSet(id: UUID(), metricValues: [.weight: 50, .reps: 8], notes: nil, drops: nil)
    let set2 = ExerciseSet(id: UUID(), metricValues: [.weight: 50, .reps: 8], notes: nil, drops: nil)
    let set3 = ExerciseSet(id: UUID(), metricValues: [.weight: 50, .reps: 8], notes: nil, drops: nil)
    let set4 = ExerciseSet(id: UUID(), metricValues: [.weight: 50, .reps: 8], notes: nil, drops: nil)
    let set5 = ExerciseSet(id: UUID(), metricValues: [.weight: 50, .reps: 8], notes: nil, drops: nil)
    let set6 = ExerciseSet(id: UUID(), metricValues: [.weight: 50, .reps: 8], notes: nil, drops: nil)
    return ApproachListView(sets: [set1, set2, set3, set4, set5, set6],
                            metrics: metrics,
                            onSetTap: { _ in },
                            onAddTap: {},
                            isLocked: false)
        .padding()
}
