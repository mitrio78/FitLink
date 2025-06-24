import SwiftUI

/// Input row for editing metrics of a single set
struct SetEditorRow: View {
    @Binding var set: ExerciseSet
    let metrics: [ExerciseMetric]
    var showLabels: Bool = true
    var scrollProxy: ScrollViewProxy? = nil

    var body: some View {
        ForEach(sortedMetrics, id: \.type) { metric in
            HStack {
                if showLabels { Text(metric.displayName) }
                Spacer()
                MetricInputField(
                    value: binding(for: metric.type),
                    labelPrefix: metric.type == .reps ? NSLocalizedString("CustomNumberPad.RepsLabel", comment: "× reps") : nil,
                    labelSuffix: metric.type != .reps ? metric.unit?.displayName : nil,
                    keyboardType: .decimalPad,
                    presets: presets(for: metric.type),
                    scrollProxy: scrollProxy,
                    scrollId: "\(set.id)-\(String(describing: metric.type))"
                )
            } //: HStack
        } //: ForEach
    }

    private var sortedMetrics: [ExerciseMetric] {
        metrics.sorted { lhs, rhs in
            order(lhs.type) < order(rhs.type)
        }
    }

    private func order(_ type: ExerciseMetricType) -> Int {
        switch type {
        case .reps: return 0
        case .weight: return 1
        default: return 2
        }
    }

    private func binding(for type: ExerciseMetricType) -> Binding<String> {
        Binding<String>(
            get: {
                guard let value = set.metricValues[type] else { return "" }
                if value == floor(value) {
                    return String(Int(value))
                } else {
                    return String(value)
                }
            },
            set: { newValue in
                let cleaned = newValue.trimLeadingZeros()
                if let number = Double(cleaned) {
                    set.metricValues[type] = number
                } else {
                    set.metricValues.removeValue(forKey: type)
                }
            }
        )
    }

    private func presets(for type: ExerciseMetricType) -> [Double] {
        [1, 2, 5, 10].map(Double.init)
    }
}

#Preview {
    let metrics = [ExerciseMetric(type: .reps, unit: .repetition, isRequired: true),
                   ExerciseMetric(type: .weight, unit: .kilogram, isRequired: false)]
    let set = ExerciseSet(id: UUID(), metricValues: [.weight: 50, .reps: 8])
    return SetEditorRow(set: .constant(set), metrics: metrics)
        .padding()
}
