import SwiftUI

/// Visual representation of a single approach/set displayed inside a horizontal list.
struct ApproachCardView: View {
    let set: ExerciseSet
    let metrics: [ExerciseMetric]

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
                VStack(spacing: 4) {
                    if let weight = weightString(for: drops[idx]) {
                        Text(weight)
                            .font(Theme.font.metrics1.bold())
                            .foregroundColor(.primary)
                    }
                    Text(metricString(for: drops[idx]))
                        .font(Theme.font.metrics2)
                        .foregroundColor(.primary)
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
    }

    private func weightString(for set: ExerciseSet) -> String? {
        guard let weightMetric else { return nil }
        return set.metricValues[.weight].map { ExerciseMetric.formattedMetric($0, metric: weightMetric) }
    }

    private func metricString(for set: ExerciseSet) -> String {
        if let repsMetric, let value = set.metricValues[.reps] {
            return ExerciseMetric.formattedMetric(value, metric: repsMetric)
        }
        if let timeMetric, let value = set.metricValues[.time] {
            return ExerciseMetric.formattedMetric(value, metric: timeMetric)
        }
        return ""
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
