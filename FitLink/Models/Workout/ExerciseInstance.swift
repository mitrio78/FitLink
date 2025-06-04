//
//  ExerciseInstance.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 30.05.2025.
//
import Foundation

/// Экземпляр упражнения в тренировке
struct ExerciseInstance: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let exercise: Exercise
    var approaches: [Approach]     // Вместо sets!
    var groupId: UUID?
    var notes: String?
}
