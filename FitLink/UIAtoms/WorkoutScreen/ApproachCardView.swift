import SwiftUI

/// Visual representation of a single approach/set displayed inside a horizontal list.
struct ApproachCardView: View {
    let set: ExerciseSet
    let metrics: [ExerciseMetric]
    var onTap: (ExerciseSet.ID) -> Void = { _ in }

    private var weightMetric: ExerciseMetric? {
        metrics.first { $0.type == .weight }
    }

    private var repsMetric: ExerciseMetric? {
        metrics.first { $0.type == .reps }
    }

    private var timeMetric: ExerciseMetric? {
        metrics.first { $0.type == .time }
    }

    var body: some View {
        HStack(spacing: 4) {
            let drops = [set] + (set.drops ?? [])
            ForEach(drops.indices, id: \.self) { idx in
                let drop = drops[idx]
                VStack(spacing: 4) {
                    if let repsMetric {
                        let val = drop.metricValues[.reps] ?? 0
                        Text(ExerciseMetric.formattedMetric(val, metric: repsMetric))
                            .font(Theme.font.metrics1.bold())
                            .foregroundColor(.primary)
                    }
                    if let weightMetric {
                        let val = drop.metricValues[.weight] ?? 0
                        Text(ExerciseMetric.formattedMetric(val, metric: weightMetric))
                            .font(Theme.font.metrics2)
                            .foregroundColor(.primary)
                    } else if let timeMetric {
                        let val = drop.metricValues[.time] ?? 0
                        Text(ExerciseMetric.formattedMetric(val, metric: timeMetric))
                            .font(Theme.font.metrics2)
                            .foregroundColor(.primary)
                    }
                }
                if idx < drops.count - 1 {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(Theme.spacing.small)
        .frame(minWidth: 64, maxHeight: .infinity)
        .background(Theme.color.textSecondary.opacity(0.05))
        .cornerRadius(Theme.radius.card)
        .contentShape(Rectangle())
        .onTapGesture { onTap(set.id) }
    }

}

#Preview {
    let metrics = [ExerciseMetric(type: .reps, unit: .repetition, isRequired: true),
                   ExerciseMetric(type: .weight, unit: .kilogram, isRequired: false)]
    let set1 = ExerciseSet(id: UUID(), metricValues: [.weight: 50, .reps: 8], notes: nil, drops: [ExerciseSet(id: UUID(), metricValues: [.weight: 40, .reps: 8], notes: nil, drops: nil)])
    return ApproachCardView(set: set1, metrics: metrics)
        .frame(height: 64)
        .padding()
}
