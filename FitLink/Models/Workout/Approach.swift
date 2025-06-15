//
//  Approach.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 31.05.2025.
//
import Foundation

struct Approach: Identifiable, Codable, Equatable, Hashable {
    var id: UUID = UUID()
    var sets: [ExerciseSet] // count == 1 if there are no drops
}
