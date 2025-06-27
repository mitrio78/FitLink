//
//  Approach.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 31.05.2025.
//
import Foundation

/// Represents one approach for an exercise. `sets` always contains at least one
/// element. When its count is greater than one, all elements after the first are
/// treated as drop steps for this approach.
struct Approach: Identifiable, Codable, Equatable, Hashable {
    var id: UUID = UUID()
    var sets: [ExerciseSet] // count == 1 if there are no drops
}
