//
//  SetsGenerator.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 30.05.2025.
//

import Foundation

func generateRegularApproaches(for exercise: Exercise, count: Int) -> [Approach] {
    (0..<count).map { index in
        var metricValues: [ExerciseMetricType: Double] = [:]
        for metric in exercise.metrics {
            switch metric.type {
            case .reps:
                metricValues[.reps] = Double(8 + Int.random(in: 0...4))
            case .weight:
                metricValues[.weight] = Double(30 + 10 * index)
            case .time:
                metricValues[.time] = Double(30 + 10 * index)
            case .distance:
                metricValues[.distance] = Double(1 + index)
            default:
                break
            }
        }
        return Approach(
            sets: [
                ExerciseSet(
                    id: UUID(),
                    metricValues: metricValues,
                    notes: (index == 0 && Bool.random()) ? "Техника, фокус!" : nil,
                    drops: nil
                )
            ]
        )
    }
}


func makeInstance(exercise: Exercise, approachesCount: Int = 3, section: WorkoutSection = .main) -> ExerciseInstance {
    ExerciseInstance(
        id: UUID(),
        exercise: exercise,
        approaches: generateRegularApproaches(for: exercise, count: approachesCount),
        groupId: nil,
        notes: nil,
        section: section
    )
}
