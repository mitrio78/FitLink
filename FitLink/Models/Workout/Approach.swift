//
//  Approach.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 31.05.2025.
//
import Foundation

enum Approach: Codable, Equatable, Hashable, Identifiable {
    case regular(ExerciseSet)
    case dropset([ExerciseSet])
    var id: UUID {
        switch self {
        case .regular(let set): return set.id
        case .dropset(let sets): return sets.first?.id ?? UUID()
        }
    }
}
