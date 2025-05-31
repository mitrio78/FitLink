//
//  ExerciseType.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import Foundation

struct Exercise: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var description: String?
    var mediaURL: URL?
    var variations: [String] // широкий, узкий хват итд
    var muscleGroups: [MuscleGroup]
    var metrics: [ExerciseMetric]
    var mainMuscle: MuscleGroup { muscleGroups.first ?? .custom("Нет") }
}
