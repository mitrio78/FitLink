import SwiftUI

/// Displays a compact vertical metrics block for a list of exercise sets.
struct ExerciseSetMetricsView: View {
    let sets: [ExerciseSet]
    let metrics: [ExerciseMetric]

    /// Tracks the width required to display all sets without scrolling.
    @State private var contentWidth: CGFloat = 0

    /// Preference key used to pass width measurements up the view tree.
    private struct WidthKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }
    
    private var weightMetric: ExerciseMetric? {
        metrics.first { $0.type == .weight }
    }
    
    private var repsMetric: ExerciseMetric? {
        metrics.first { $0.type == .reps }
    }
    
    private var timeMetric: ExerciseMetric? {
        metrics.first { $0.type == .time }
    }

    /// HStack containing the metrics for up to four sets.
    @ViewBuilder
    private func metricsContent() -> some View {
        HStack(spacing: Theme.spacing.medium) {
            ForEach(Array(sets.prefix(4).enumerated()), id: \.offset) { index, set in
                HStack(alignment: .center, spacing: 6) {
                    let drops = [set] + (set.drops ?? [])
                    ForEach(drops.indices, id: \.self) { idx in
                        VStack(spacing: 2) {
                            Text(weightString(for: drops[idx]))
                                .font(.headline.bold())
                            Text(metricString(for: drops[idx]))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        if idx < drops.count - 1 {
                            Text("→")
                                .font(.headline.bold())
                                .padding(.horizontal, 2)
                        } else {
                            Divider()
                                .padding(.leading)
                        }
                    }
                }
            }
        }
    }

    /// Metrics content wrapped with a background geometry reader to measure width.
    private var measuredContent: some View {
        metricsContent()
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(key: WidthKey.self, value: proxy.size.width)
                }
            )
    }

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                Divider()
                    .padding(.vertical, 4)
                if contentWidth > geo.size.width {
                    ScrollView(.horizontal, showsIndicators: false) {
                        metricsContent()
                    }
                } else {
                    metricsContent()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .background(measuredContent.opacity(0))
            .onPreferenceChange(WidthKey.self) { contentWidth = $0 }
        }
    }
    
    private func weightString(for set: ExerciseSet) -> String {
        guard let weightMetric else { return "" }
        return set.metricValues[.weight].map { ExerciseMetric.formattedMetric($0, metric: weightMetric) } ?? ""
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
    let set2 = ExerciseSet(id: UUID(), metricValues: [.weight: 55, .reps: 6], notes: nil, drops: nil)
    return ExerciseSetMetricsView(sets: [set1, set2, set1, set2, set1, set2, set1, set2], metrics: metrics)
        .padding()
}
