import SwiftUI

/// Horizontally scrollable list of exercise approaches.
struct ApproachListView: View {
    let sets: [ExerciseSet]
    let metrics: [ExerciseMetric]
    var onTap: () -> Void = {}

    private var gridRows: [GridItem] { [GridItem(.fixed(64))] }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: gridRows, spacing: Theme.spacing.small) {
                if sets.isEmpty {
                    Button(action: onTap) {
                        Image(systemName: "plus")
                            .frame(width: 64, height: 64)
                            .foregroundColor(.primary)
                            .background(Theme.color.backgroundSecondary)
                            .cornerRadius(Theme.radius.card)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                } else {
                    ForEach(sets) { set in
                        Button(action: onTap) {
                            ApproachCardView(set: set, metrics: metrics)
                                .frame(height: 64)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .contentShape(Rectangle())
            .padding(.vertical, Theme.spacing.small)
        }
        .highPriorityGesture(DragGesture()) // ensure horizontal scroll isn't intercepted
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
