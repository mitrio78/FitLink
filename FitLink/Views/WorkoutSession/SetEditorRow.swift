import SwiftUI

/// Input row for editing metrics of a single set
struct SetEditorRow: View {
    @Binding var set: ExerciseSet
    let metrics: [ExerciseMetric]

    private let numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 2
        return f
    }()

    var body: some View {
        ForEach(metrics, id: \.type) { metric in
            HStack {
                Text(metric.displayName)
                Spacer()
                TextField("0", value: binding(for: metric.type), formatter: numberFormatter)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.primary)
            }
        }
    }

    private func binding(for type: ExerciseMetricType) -> Binding<Double> {
        Binding<Double>(
            get: { set.metricValues[type] ?? 0 },
            set: { set.metricValues[type] = $0 }
        )
    }
}

#Preview {
    let metrics = [ExerciseMetric(type: .reps, unit: .repetition, isRequired: true),
                   ExerciseMetric(type: .weight, unit: .kilogram, isRequired: false)]
    var set = ExerciseSet(id: UUID(), metricValues: [.weight: 50, .reps: 8])
    return SetEditorRow(set: .constant(set), metrics: metrics)
        .padding()
}
