import SwiftUI

/// View representing a single approach in the superset.
struct SupersetApproachView: View {
    let index: Int
    let items: [(exercise: ExerciseInstance, approach: Approach?)]
    var onSetsEdit: (ExerciseInstance) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small) {
            Text(String(format: NSLocalizedString("SupersetApproachView.Title", comment: "Approach %d"), index))
                .font(Theme.font.subheading.bold())
                .foregroundColor(Theme.color.accent)
            ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                if idx > 0 {
                    Divider()
                        .background(Theme.color.border.opacity(0.3))
                }
                VStack(alignment: .leading, spacing: Theme.spacing.small / 2) {
                    Text(item.exercise.exercise.name)
                        .font(Theme.font.body).bold()
                    ApproachListView(
                        sets: combinedSets(for: item.approach),
                        metrics: item.exercise.exercise.metrics,
                        onTap: { onSetsEdit(item.exercise) }
                    )
                }
            }
        } //: VStack
    }

    private func combinedSets(for approach: Approach?) -> [ExerciseSet] {
        guard let approach else { return [] }
        var first = approach.sets.first ?? ExerciseSet(id: UUID(), metricValues: [:], notes: nil, drops: nil)
        first.drops = Array(approach.sets.dropFirst())
        return [first]
    }
}

#Preview {
    let metrics = [ExerciseMetric(type: .reps, unit: .reps, isRequired: true),
                   ExerciseMetric(type: .weight, unit: .kg, isRequired: false)]
    let ex = ExerciseInstance(id: UUID(), exercise: Exercise(id: UUID(), name: "Test", variations: [], muscleGroups: [.chest], metrics: metrics), approaches: [], groupId: nil, notes: nil)
    return SupersetApproachView(index: 1, items: [(ex, nil)])
}
