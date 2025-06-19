import SwiftUI

/// Input row for editing metrics of a single set
struct SetEditorRow: View {
    @Binding var set: ExerciseSet
    let metrics: [ExerciseMetric]
    var showLabels: Bool = true

    var body: some View {
        ForEach(metrics, id: \.type) { metric in
            MetricInputField(value: binding(for: metric.type), metric: metric, showLabel: showLabels)
        }
    }

    private func binding(for type: ExerciseMetricType) -> Binding<Double?> {
        Binding<Double?>(
            get: { set.metricValues[type] },
            set: { newValue in
                if let value = newValue {
                    set.metricValues[type] = value
                } else {
                    set.metricValues.removeValue(forKey: type)
                }
            }
        )
    }
}

#Preview {
    let metrics = [ExerciseMetric(type: .reps, unit: .repetition, isRequired: true),
                   ExerciseMetric(type: .weight, unit: .kilogram, isRequired: false)]
    let set = ExerciseSet(id: UUID(), metricValues: [.weight: 50, .reps: 8])
    return SetEditorRow(set: .constant(set), metrics: metrics)
        .padding()
}
