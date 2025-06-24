import SwiftUI

/// Horizontally scrollable list of exercise approaches.
struct ApproachListView: View {
    let sets: [ExerciseSet]
    let metrics: [ExerciseMetric]
    var onMetricTap: (ExerciseSet.ID, ExerciseMetric) -> Void = { _, _ in }

    private var gridRows: [GridItem] { [GridItem(.fixed(64))] }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: gridRows, spacing: Theme.spacing.small) {
                ForEach(sets) { set in
                    ApproachCardView(set: set, metrics: metrics) { id, metric in
                        onMetricTap(id, metric)
                    }
                    .frame(height: 64)
                }
            }
            .padding(.vertical, Theme.spacing.small)
        } //: ScrollView
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
    return ApproachListView(sets: [set1, set2, set3, set4, set5, set6], metrics: metrics)
        .padding()
}
