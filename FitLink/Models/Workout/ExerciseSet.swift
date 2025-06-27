//
//  ExerciseSet.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 30.05.2025.
//

import Foundation

/// Подход
struct ExerciseSet: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var metricValues: [ExerciseMetricType: ExerciseMetricValue]
    var notes: String?
    var drops: [ExerciseSet]? // добавь этот массив
}
