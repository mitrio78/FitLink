import SwiftUI

/// Visual representation of a single approach/set displayed inside a horizontal list.
struct ApproachCardView: View {
    let set: ExerciseSet
    let metrics: [ExerciseMetric]
    var onTap: (_ setID: ExerciseSet.ID) -> Void = { _ in }
    var onDropTap: (_ dropID: ExerciseSet.ID, _ index: Int) -> Void = { _, _ in }

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
        let lineSpacing = Theme.spacing.metricLineSpacing
        HStack(spacing: innerSpacing) {
            let drops = [set] + (set.drops ?? [])
            ForEach(drops.indices, id: \.self) { idx in
                let drop = drops[idx]
                VStack(spacing: lineSpacing) {
                    if let repsMetric {
                        let val = drop.metricValues[.reps] ?? .int(0)
                        Text(ExerciseMetric.formattedMetric(val, metric: repsMetric))
                            .font(Theme.current.layoutMode == .compact ? Theme.font.compactMetricValue.bold() : Theme.font.metrics1.bold())
                            .foregroundColor(.primary)
                    }
                    if let weightMetric {
                        let val = drop.metricValues[.weight] ?? .double(0)
                        Text(ExerciseMetric.formattedMetric(val, metric: weightMetric))
                            .font(Theme.current.layoutMode == .compact ? Theme.font.compactMetricValue : Theme.font.metrics2)
                            .foregroundColor(.primary)
                    } else if let timeMetric {
                        let val = drop.metricValues[.time] ?? .double(0)
                        Text(ExerciseMetric.formattedMetric(val, metric: timeMetric))
                            .font(Theme.current.layoutMode == .compact ? Theme.font.compactMetricValue : Theme.font.metrics2)
                            .foregroundColor(.primary)
                    }
                } //: VStack
                .contentShape(Rectangle())
                .onTapGesture { onDropTap(drop.id, idx) }
                if idx < drops.count - 1 {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        } //: HStack
        .fixedSize(horizontal: false, vertical: true)
        .metricCardStyle()
        .contentShape(Rectangle())
        .onTapGesture { onTap(set.id) }
    }

}

#Preview {
    let metrics = [ExerciseMetric(type: .reps, unit: .repetition, isRequired: true),
                   ExerciseMetric(type: .weight, unit: .kilogram, isRequired: false)]
    let set1 = ExerciseSet(id: UUID(), metricValues: [.weight: .double(50), .reps: .int(8)], notes: nil, drops: [ExerciseSet(id: UUID(), metricValues: [.weight: .double(40), .reps: .int(8)], notes: nil, drops: nil)])
    return ApproachCardView(set: set1, metrics: metrics, onTap: { _ in }, onDropTap: { _, _ in })
        .padding()
}
