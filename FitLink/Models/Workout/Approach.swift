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

    /// Convenience accessor that merges `set` with its `drops` array.
    /// This allows views that operate on `ExerciseSet` to access dropsets
    /// without needing to know about the `Approach` container.
    var setWithDrops: ExerciseSet {
        var copy = set
        copy.drops = drops
        return copy
    }
}
