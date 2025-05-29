//
//  WorkoutSession.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//

import Foundation

/// `Связи и бизнес-логика`
///
/// `Exercise` — справочник упражнений (не дублируется для каждого случая).
/// `ExerciseVariation` — варианты выполнения этого упражнения, вложены в сам`Exercise`.
/// `WorkoutExercise` — конкретный случай применения упражнения (с выбранной вариацией и наборами подходов/сетами).
/// `WorkoutSession` — вся тренировка клиента за дату-время.
/// Даже если в одной тренировке есть 2 суперсета, где используются одни и те же упражнения,
/// разные `WorkoutExercise` могут ссылаться на один и тот же `Exercise`,
/// но с разными вариациями и сетами.

struct WorkoutSession: Identifiable {
    let id: UUID
    let clientId: UUID
    let clientName: String
    let date: Date
    let time: String
    let exercises: [WorkoutExercise]
    let notes: String?
}

struct WorkoutExercise: Identifiable {
    let id = UUID()
    let exercise: Exercise
    let variation: ExerciseVariation? // если есть (например, дропсет, суперсет, и т.д.)
    let sets: [ExerciseSet]           // разные подходы (возможно, с разными весами/повторами)
}

struct ExerciseSet: Identifiable {
    let id = UUID()
    let order: Int                // номер сета
    let reps: Int?                // повторения (если применимо)
    let weight: Double?           // вес (если применимо)
    let duration: Double?         // секунды (если тренировка на время)
    let notes: String?            // доп. примечание к сету
}
