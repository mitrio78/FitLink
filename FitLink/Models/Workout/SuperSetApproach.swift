//
//  SuperSetApproach.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 31.05.2025.
//

import Foundation

struct SupersetApproach: Identifiable {
    let id = UUID()
    let exercises: [ExerciseResult]
}

struct ExerciseResult: Identifiable {
    let id = UUID()
    let exerciseName: String
    let metricValues: [MetricValue]
}

// Лучше вынести в отдельную структуру:
struct MetricValue: Identifiable {
    let id = UUID()
    let type: ExerciseMetricType
    let displayName: String
    let value: String
    let iconName: String?
}
