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
        let innerSpacing = Theme.current.layoutMode == .compact ? Theme.current.spacing.compactInnerSpacing : Theme.spacing.small / 2
        let horizontalPadding = Theme.current.layoutMode == .compact ? Theme.current.spacing.compactMetricHorizontalPadding : Theme.spacing.small
        let verticalPadding = Theme.current.layoutMode == .compact ? Theme.current.spacing.compactMetricVerticalPadding : Theme.spacing.small
        let corner = Theme.current.layoutMode == .compact ? Theme.current.radius.compactSetCell : Theme.radius.card
        HStack(spacing: innerSpacing) {
            let drops = [set] + (set.drops ?? [])
            ForEach(drops.indices, id: \.self) { idx in
                let drop = drops[idx]
                VStack(spacing: innerSpacing) {
                    if let repsMetric {
                        let val = drop.metricValues[.reps] ?? 0
                        Text(ExerciseMetric.formattedMetric(val, metric: repsMetric))
                            .font(Theme.current.layoutMode == .compact ? Theme.font.compactMetricValue.bold() : Theme.font.metrics1.bold())
                            .foregroundColor(.primary)
                    }
                    if let weightMetric {
                        let val = drop.metricValues[.weight] ?? 0
                        Text(ExerciseMetric.formattedMetric(val, metric: weightMetric))
                            .font(Theme.current.layoutMode == .compact ? Theme.font.compactMetricValue : Theme.font.metrics2)
                            .foregroundColor(.primary)
                    } else if let timeMetric {
                        let val = drop.metricValues[.time] ?? 0
                        Text(ExerciseMetric.formattedMetric(val, metric: timeMetric))
                            .font(Theme.current.layoutMode == .compact ? Theme.font.compactMetricValue : Theme.font.metrics2)
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
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .frame(minWidth: 64, maxHeight: .infinity)
        .background(Theme.color.textSecondary.opacity(0.05))
        .cornerRadius(corner)
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
