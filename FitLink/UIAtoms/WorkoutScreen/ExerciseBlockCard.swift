//
//  ExerciseBlockCard.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 31.05.2025.
//
import SwiftUI

/// Универсальная карточка упражнения/группы для экрана тренировки
struct ExerciseBlockCard: View {
    let group: SetGroup?
    let exerciseInstances: [ExerciseInstance]
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            // Header (compact)
            HStack(spacing: 8) {
                if let group = group {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 8) {
                            VariationTypeBadge(text: group.type.displayName, color: group.type.color)
                        }
                        // Названия упражнений — всегда с новой строки
                        if group.type == .superset {
                            ForEach(exerciseInstances, id: \ .id) { ex in
                                Text(ex.exercise.name)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        } else if let first = exerciseInstances.first {
                            Text(first.exercise.name)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                } else if let exercise = exerciseInstances.first {
                    Text(exercise.exercise.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("×\(setCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
            .onTapGesture { withAnimation { isExpanded.toggle() } }

            if isExpanded {
                Divider()
                VStack(alignment: .leading, spacing: 0) {
                    expandedContent
                }
                .padding(16) // внутренний отступ для контента
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(borderColor, lineWidth: 2)
                )
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }

    private var setCount: Int {
        if group != nil {
            // Для групп считаем максимальное число подходов среди всех упражнений
            return exerciseInstances.map { $0.approaches.count }.max() ?? 0
        } else if let exercise = exerciseInstances.first {
            return exercise.approaches.count
        }
        return 0
    }

    private var backgroundColor: Color {
        group?.type.color.opacity(0.07) ?? Color(.secondarySystemBackground)
    }
    private var borderColor: Color {
        group?.type.color ?? .clear
    }

    @ViewBuilder
    private var expandedContent: some View {
        if let group = group {
            switch group.type {
            case .dropset:
                ForEach(exerciseInstances) { ex in
                    DropSetView(exercise: ex, approaches: ex.approaches.map { DropSetApproach(steps: [$0.set] + $0.drops) })
                }
            case .superset:
                SuperSetView(sets: supersetApproaches)
            default:
                // future: circuit, pyramid, etc.
                EmptyView()
            }
        } else if let exercise = exerciseInstances.first {
            ExerciseApproachListView(exerciseInstance: exercise)
        }
    }

    // Собираем данные для SuperSetView
    private var supersetApproaches: [SupersetApproach] {
        // Собираем подходы суперсета в табличный вид:
        // Для каждого индекса подхода собираем ExerciseResult для каждого упражнения
        guard !exerciseInstances.isEmpty else { return [] }
        let maxApproaches = exerciseInstances.map { $0.approaches.count }.max() ?? 0
        var result: [SupersetApproach] = []
        for setIndex in 0..<maxApproaches {
            var exerciseResults: [ExerciseResult] = []
            for ex in exerciseInstances {
                if ex.approaches.indices.contains(setIndex) {
                    let approach = ex.approaches[setIndex]
                    let metrics = ex.exercise.metrics
                    let metricValues: [MetricValue] = metrics.compactMap { metric in
                        if let value = approach.set.metricValues[metric.type] {
                            return MetricValue(type: metric.type, displayName: metric.type.displayName, value: ExerciseMetric.formattedMetric(value, metric: metric), iconName: metric.iconName)
                        } else {
                            return nil
                        }
                    }
                    exerciseResults.append(ExerciseResult(exerciseName: ex.exercise.name, metricValues: metricValues))
                } else {
                    // Если подхода нет, добавляем пустой
                    exerciseResults.append(ExerciseResult(exerciseName: ex.exercise.name, metricValues: []))
                }
            }
            result.append(SupersetApproach(exercises: exerciseResults))
        }
        return result
    }
}
