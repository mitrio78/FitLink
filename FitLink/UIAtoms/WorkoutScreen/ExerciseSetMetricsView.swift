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
        let dividerPadding = Theme.isCompactUIEnabled ? Theme.spacing.compactInnerSpacing : Theme.spacing.small / 2
        let outerSpacing = Theme.isCompactUIEnabled ? Theme.spacing.compactMetricSpacing : Theme.spacing.medium
        let innerSpacing = Theme.isCompactUIEnabled ? Theme.spacing.compactMetricSpacing : Theme.spacing.small
        let vSpacing = Theme.isCompactUIEnabled ? Theme.spacing.compactMetricSpacing / 2 : Theme.spacing.small / 2

        VStack {
            Divider()
                .padding(.vertical, dividerPadding)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: outerSpacing) {
                    ForEach(Array(sets.prefix(4).enumerated()), id: \.offset) { index, set in
                        HStack(alignment: .center, spacing: innerSpacing) {
                            let drops = [set] + (set.drops ?? [])
                            ForEach(drops.indices, id: \.self) { idx in
                                VStack(spacing: vSpacing) {
                                    // Верхняя строка — вес
                                    Text(weightString(for: drops[idx]))
                                        .font(Theme.isCompactUIEnabled ? Theme.font.compactMetricValue.bold() : .headline.bold())
                                        .foregroundColor(.primary)
                                    // Нижняя строка — метрика
                                    Text(metricString(for: drops[idx]))
                                        .font(Theme.isCompactUIEnabled ? Theme.font.compactMetricValue : .subheadline)
                                        .foregroundColor(.primary)
                                }
                                // Стрелка — если не последний дроп
                                if idx < drops.count - 1 {
                                    Text("→")
                                        .font(Theme.isCompactUIEnabled ? Theme.font.compactMetricValue.bold() : .headline.bold())
                                        .padding(.horizontal, Theme.isCompactUIEnabled ? Theme.spacing.compactMetricSpacing / 2 : Theme.spacing.small / 2)
                                } else {
                                    Divider()
                                        .padding(.leading)
                                }
                            }
                        }
                    } // ForEach
                } // HStack
            } // Scroll
        }
    }
    
    private func weightString(for set: ExerciseSet) -> String {
        guard let weightMetric else { return "" }
        let value = set.metricValues[.weight] ?? 0
        return ExerciseMetric.formattedMetric(value, metric: weightMetric)
    }
    
    private func metricString(for set: ExerciseSet) -> String {
        if let repsMetric {
            let value = set.metricValues[.reps] ?? 0
            return ExerciseMetric.formattedMetric(value, metric: repsMetric)
        }
        if let timeMetric {
            let value = set.metricValues[.time] ?? 0
            return ExerciseMetric.formattedMetric(value, metric: timeMetric)
        }
        return ""
    }
}

#Preview {
    let metrics = [ExerciseMetric(type: .reps, unit: .repetition, isRequired: true),
                   ExerciseMetric(type: .weight, unit: .kilogram, isRequired: false)]
    let set1 = ExerciseSet(id: UUID(), metricValues: [.weight: 50, .reps: 8], notes: nil, drops: [ExerciseSet(id: UUID(), metricValues: [.weight: 40, .reps: 8], notes: nil, drops: nil)])
    let set2 = ExerciseSet(id: UUID(), metricValues: [.weight: 55, .reps: 6], notes: nil, drops: nil)
    return ExerciseSetMetricsView(sets: [set1, set2, set1, set2, set1, set2, set1, set2], metrics: metrics)
        .padding()
}
