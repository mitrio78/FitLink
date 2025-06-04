//
//  ExerciseSetRow.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//
import SwiftUI

struct ExerciseSetRow: View {
    let set: ExerciseSet
    let metrics: [ExerciseMetric]
    let index: Int
    
    @State private var actualValues: [ExerciseMetricType: Double] = [:]
    @State private var completed: Bool = false
    @State private var notes: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Сет \(index + 1):")
                    .font(.caption)
                Spacer()
                Toggle("", isOn: $completed)
                    .toggleStyle(CheckboxToggleStyle())
                    .labelsHidden()
            }
            
            // Плановые значения
            HStack(spacing: 4) {
                ForEach(metrics, id: \.type) { metric in
                    if let planned = set.metricValues[metric.type] {
                        HStack(spacing: 2) {
                            Text(metric.displayName)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text(metricValueString(value: planned, unit: metric.unit))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            // Фактические значения: редактируются всегда
            HStack(spacing: 6) {
                Text("Факт:")
                    .font(.caption2)
                ForEach(metrics, id: \.type) { metric in
                    HStack(spacing: 2) {
                        Text(metric.displayName)
                            .font(.caption2)
                        TextField(
                            metric.displayName,
                            value: Binding(
                                get: { actualValues[metric.type] ?? set.metricValues[metric.type] ?? 0 },
                                set: { actualValues[metric.type] = $0 }
                            ),
                            formatter: metricFormatter(for: metric.type)
                        )
                        .keyboardType(.decimalPad)
                        .frame(width: 54)
                        if let unit = metric.unit {
                            Text(unit.displayName)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            // RPE если нужна (добавь в metrics ExerciseMetric(type: .custom("RPE"), ...))
            if metrics.contains(where: { $0.type == .custom("RPE") }) {
                HStack {
                    Text("RPE:")
                    Slider(value: Binding(
                        get: { actualValues[.custom("RPE")] ?? 5 },
                        set: { actualValues[.custom("RPE")] = $0 }
                    ), in: 1...10, step: 1)
                    Text("\(Int(actualValues[.custom("RPE")] ?? 5))")
                }
                .font(.caption2)
            }

            // Редактируемые заметки к сету
            TextField("Заметка к сету", text: $notes)
                .font(.caption2)
                .foregroundColor(.yellow)
        }
        .padding(.vertical, 4)
    }
    
    // Форматирование значений
    private func metricValueString(value: Double, unit: UnitType?) -> String {
        let intValue = Int(value)
        if value == Double(intValue) {
            return unit == nil ? "\(intValue)" : "\(intValue) \(unit!.displayName)"
        } else {
            return unit == nil ? "\(value)" : "\(value) \(unit!.displayName)"
        }
    }
    private func metricFormatter(for type: ExerciseMetricType) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

#if DEBUG
struct ExerciseSetRow_Previews: PreviewProvider {
    static var previews: some View {
        let metrics = [ExerciseMetric(type: .reps, isRequired: true), ExerciseMetric(type: .weight, isRequired: false)]
        let set = ExerciseSet(id: UUID(), metricValues: [.reps: 10, .weight: 50], notes: nil, drops: nil)
        ExerciseSetRow(set: set, metrics: metrics, index: 0)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
