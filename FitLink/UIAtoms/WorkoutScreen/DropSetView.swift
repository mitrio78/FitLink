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
            Text(exercise.exercise.name)
//                .font(.subheadline.bold())
//                .padding(.leading, 6)
//                .padding(.top, 2)
                .font(.body.bold())
                .lineLimit(2)
                .minimumScaleFactor(0.9)
            
            ForEach(Array(approaches.enumerated()), id: \.element.id) { idx, app in
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Подход \(idx + 1)")
                            .font(.headline)
                            .foregroundColor(.orange)
                        Spacer()
                        // (Можно добавить метку или иконку, если нужно)
                    }
                    ForEach(Array(app.steps.enumerated()), id: \.element.id) { i, step in
                        HStack(alignment: .center, spacing: 10) {
                            // Индикатор основной/дроп
                            Circle()
                                .fill(i == 0 ? Color.orange : Color.orange.opacity(0.4))
                                .frame(width: 8, height: 8)
                            Text(i == 0 ? "Основной" : "Дроп \(i)")
                                .font(.caption2)
                                .frame(width: 65, alignment: .leading)
                                .foregroundColor(i == 0 ? .orange : .primary)
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
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 3)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.orange.opacity(0.07), radius: 6, x: 0, y: 2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.orange.opacity(0.14), lineWidth: 1)
                )
            }
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 2)
        .padding(.bottom, 8)
    }
}


// ===== PREVIEW ======

struct DropSetView_Previews: PreviewProvider {
    static var previews: some View {
        DropSetView(
            exercise: mockDropSetInstance,
            approaches: mockDropSetApproaches
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemBackground))
    }
}

// ===== MOCKS for Preview =====

// Пример Step (ExerciseSet)
let mockDropSetSteps = [
    ExerciseSet(
        id: UUID(),
        metricValues: [.reps: 8, .weight: 50],
        notes: "Основной вес"
    ),
    ExerciseSet(
        id: UUID(),
        metricValues: [.reps: 8, .weight: 40],
        notes: "Дроп 1"
    ),
    ExerciseSet(
        id: UUID(),
        metricValues: [.reps: 8, .weight: 30],
        notes: "Дроп 2"
    )
]

let mockDropSetApproaches = [
    DropSetApproach(steps: mockDropSetSteps)
]

// Пример ExerciseInstance для превью
let mockDropSetInstance = ExerciseInstance(
    id: UUID(),
    exercise: Exercise(
        id: UUID(),
        name: "Жим лёжа",
        description: "Базовое упражнение для грудных мышц.",
        mediaURL: nil,
        variations: ["Классический"],
        muscleGroups: [.chest, .triceps],
        metrics: [
            ExerciseMetric(type: .reps, isRequired: true),
            ExerciseMetric(type: .weight, isRequired: true)
        ]
    ),
    approaches: [dropSetApproach1],
    groupId: nil,
    notes: nil
)
