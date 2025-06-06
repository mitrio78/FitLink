//
//  DropSetView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 30.05.2025.
//
import SwiftUI

struct DropSetView: View {
    let exercise: ExerciseInstance
    let approaches: [DropSetApproach]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(approaches.enumerated()), id: \.element.id) { idx, app in
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(String(format: NSLocalizedString("DropSetView.Title", comment: "Подход %d"), idx + 1))
                            .font(.headline)
                            .foregroundColor(.orange)
                            .padding(.bottom, 6)
                        // (Можно добавить метку или иконку, если нужно)
                    }
                    ForEach(Array(app.steps.enumerated()), id: \.element.id) { i, step in
                        HStack(alignment: .center, spacing: 12) {
                            // Индикатор основной/дроп
                            Circle()
                                .fill(i == 0 ? Color.orange : Color.orange.opacity(0.4))
                                .frame(width: 10, height: 10)
                            Text(i == 0 ? NSLocalizedString("DropSetView.MainStep", comment: "Основной") : String(format: NSLocalizedString("DropSetView.DropStep", comment: "Дроп %d"), i))
                                .font(.body)
                                .foregroundColor( .primary)
                            Spacer()
                            // Универсальный перебор метрик
                            ForEach(exercise.exercise.metrics, id: \.type) { metric in
                                if let value = step.metricValues[metric.type] {
                                    HStack(spacing: 4) {
                                        if let icon = metric.iconName {
                                            Image(systemName: icon)
                                                .font(.system(size: 14))
                                                .foregroundColor(.secondary)
                                        }
                                        Text("\(ExerciseMetric.formattedMetric(value, metric: metric))")
                                            .font(.body)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 3)
                    }
                    .padding(.bottom, 6)
                    // Divider()
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 2)
        .padding(.bottom, 8)
    }
}


// ===== PREVIEW ======

#if DEBUG
struct DropSetView_Previews: PreviewProvider {
    static var previews: some View {
        let metrics = [ExerciseMetric(type: .reps, isRequired: true), ExerciseMetric(type: .weight, isRequired: false)]
        let set1 = ExerciseSet(id: UUID(), metricValues: [.reps: 8, .weight: 50], notes: nil, drops: nil)
        let set2 = ExerciseSet(id: UUID(), metricValues: [.reps: 8, .weight: 40], notes: nil, drops: nil)
        let set3 = ExerciseSet(id: UUID(), metricValues: [.reps: 8, .weight: 30], notes: nil, drops: nil)
        let approach = DropSetApproach(steps: [set1, set2, set3])
        let exercise = ExerciseInstance(id: UUID(), exercise: Exercise(id: UUID(), name: "Жим лёжа", description: "", mediaURL: nil, variations: [], muscleGroups: [], metrics: metrics), approaches: [], groupId: nil, notes: nil)
        DropSetView(exercise: exercise, approaches: [approach])
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
