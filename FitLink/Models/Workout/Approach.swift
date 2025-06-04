//
//  Approach.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 31.05.2025.
//
import Foundation

struct Approach: Identifiable, Codable, Equatable, Hashable {
    var id: UUID = UUID()
    var set: ExerciseSet
    var drops: [ExerciseSet] // Пустой если нет дропов
}
