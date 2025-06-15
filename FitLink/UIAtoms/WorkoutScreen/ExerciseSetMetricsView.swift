import SwiftUI

/// Displays a compact vertical metrics block for a list of exercise sets.
struct ExerciseSetMetricsView: View {
    let sets: [ExerciseSet]
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
        HStack(spacing: Theme.spacing.medium) {
            ForEach(Array(sets.prefix(4).enumerated()), id: \.offset) { index, set in
                VStack(spacing: 2) {
                    Text(weightString(for: set))
                        .font(.headline.bold())
                    Text(metricString(for: set))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .accessibilityLabel(accessibilityText(for: set, index: index))
            }
            if sets.count > 4 {
                VStack(spacing: 2) {
                    Spacer(minLength: 0)
                    Text("…")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    private func weightString(for set: ExerciseSet) -> String {
        guard let weightMetric else { return "" }
        let allSets = [set] + (set.drops ?? [])
        let values = allSets.compactMap { s in
            s.metricValues[.weight].map { ExerciseMetric.formattedMetric($0, metric: weightMetric) }
        }
        return values.isEmpty ? "" : values.joined(separator: "\u{2192}")
    }

    private func metricString(for set: ExerciseSet) -> String {
        if let repsMetric {
            let allSets = [set] + (set.drops ?? [])
            let values = allSets.compactMap { s in
                s.metricValues[.reps].map { ExerciseMetric.formattedMetric($0, metric: repsMetric) }
            }
            if !values.isEmpty { return values.joined(separator: "\u{2192}") }
        }
        if let timeMetric {
            let allSets = [set] + (set.drops ?? [])
            let values = allSets.compactMap { s in
                s.metricValues[.time].map { ExerciseMetric.formattedMetric($0, metric: timeMetric) }
            }
            if !values.isEmpty { return values.joined(separator: "\u{2192}") }
        }
        return ""
    }

    private func accessibilityText(for set: ExerciseSet, index: Int) -> String {
        var parts: [String] = [String(format: NSLocalizedString("ExerciseSetRow.SetTitle", comment: "Set %d:"), index + 1)]
        let w = weightString(for: set)
        if !w.isEmpty { parts.append(w) }
        let r = metricString(for: set)
        if !r.isEmpty { parts.append(r) }
        return parts.joined(separator: ", ")
    }
}

#Preview {
    let metrics = [ExerciseMetric(type: .reps, unit: .repetition, isRequired: true),
                    ExerciseMetric(type: .weight, unit: .kilogram, isRequired: false)]
    let set1 = ExerciseSet(id: UUID(), metricValues: [.weight: 50, .reps: 8], notes: nil, drops: [ExerciseSet(id: UUID(), metricValues: [.weight: 40, .reps: 8], notes: nil, drops: nil)])
    let set2 = ExerciseSet(id: UUID(), metricValues: [.weight: 55, .reps: 6], notes: nil, drops: nil)
    return ExerciseSetMetricsView(sets: [set1, set2], metrics: metrics)
        .padding()
        .previewLayout(.sizeThatFits)
}
