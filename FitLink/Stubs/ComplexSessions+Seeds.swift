//
//  ComplexSessions+Seeds.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 30.05.2025.
//

// Предположим exercisesCatalog уже определён как раньше
// Для простоты возьмём индексы 0: "Жим лёжа", 6: "Сгибания рук с гантелями", 13: "Тяга штанги в наклоне"

import Foundation

let dropSetExercise = exercisesCatalog[0] // Жим лёжа

let dropSetApproach1 = Approach(
    set: ExerciseSet(
        id: UUID(),
        metricValues: [.reps: 8, .weight: 50],
        notes: "Основной вес"
    ),
    drops: [
        ExerciseSet(
            id: UUID(),
            metricValues: [.reps: 8, .weight: 40],
            notes: "Дроп 1"
        ),
        ExerciseSet(
            id: UUID(),
            metricValues: [.reps: 8, .weight: 30],
            notes: "Дроп 2"
        )
    ]
)

let dropSetApproach2 = Approach(
    set: ExerciseSet(
        id: UUID(),
        metricValues: [.reps: 7, .weight: 45],
        notes: "Основной вес"
    ),
    drops: [
        ExerciseSet(
            id: UUID(),
            metricValues: [.reps: 7, .weight: 35],
            notes: "Дроп 1"
        ),
        ExerciseSet(
            id: UUID(),
            metricValues: [.reps: 7, .weight: 25],
            notes: "Дроп 2"
        )
    ]
)

let dropSetInstance = ExerciseInstance(
    id: UUID(),
    exercise: dropSetExercise,
    approaches: [dropSetApproach1, dropSetApproach2],
    groupId: nil,
    notes: "Дропсет: два подхода, по три ступени"
)

// Генератор подходов-дропсетов из ExerciseInstance (если их несколько — каждый Approach.dropset отдельно)
func makeDropSetApproaches(for ex: ExerciseInstance) -> [DropSetApproach] {
    ex.approaches.map { approach in
        DropSetApproach(steps: [approach.set] + approach.drops)
    }
}



// Суперсет из двух упражнений: сгибания рук и тяга штанги
// Для суперсета нам нужно, чтобы в каждом подходе был Approach.regular для каждого упражнения
func generateRegularApproaches(for exercise: Exercise, reps: [Int], weights: [Double]) -> [Approach] {
    zip(reps, weights).map { (rep, weight) in
        Approach(
            set: ExerciseSet(
                id: UUID(),
                metricValues: [.reps: Double(rep), .weight: weight],
                notes: nil
            ),
            drops: []
        )
    }
}

let superSetInstance1 = ExerciseInstance(
    id: UUID(),
    exercise: exercisesCatalog[6], // Сгибания рук с гантелями
    approaches: generateRegularApproaches(for: exercisesCatalog[6], reps: [9,8,8], weights: [30,35,30]),
    groupId: nil,
    notes: nil
)
let superSetInstance2 = ExerciseInstance(
    id: UUID(),
    exercise: exercisesCatalog[13], // Тяга штанги в наклоне
    approaches: generateRegularApproaches(for: exercisesCatalog[13], reps: [9,10,8], weights: [30,40,35]),
    groupId: nil,
    notes: nil
)


/// Генерирует массив подходов для суперсета
func makeSupersetApproaches(
    group: SetGroup,
    allExercises: [ExerciseInstance]
) -> [SupersetApproach] {
    let instances = group.exerciseInstanceIds.compactMap { id in
        allExercises.first(where: { $0.id == id })
    }
    guard !instances.isEmpty else { return [] }

    let approachesList: [[Approach]] = instances.map { $0.approaches }
    let approachesCount = approachesList.map { $0.count }.min() ?? 0
    guard approachesCount > 0 else { return [] }

    var result: [SupersetApproach] = []
    for i in 0..<approachesCount {
        let exerciseResults: [ExerciseResult] = zip(instances, approachesList).map { (instance, approaches) in
            let set = approaches[i].set
            let metrics = instance.exercise.metrics

            let metricValues: [MetricValue] = metrics.compactMap { metric in
                guard let rawValue = set.metricValues[metric.type] else { return nil }
                let valueString = ExerciseMetric.formattedMetric(rawValue, metric: metric)
                return MetricValue(
                    type: metric.type,
                    displayName: metric.displayName,
                    value: valueString,
                    iconName: metric.iconName
                )
            }

            return ExerciseResult(
                exerciseName: instance.exercise.name,
                metricValues: metricValues
            )
        }
        result.append(SupersetApproach(exercises: exerciseResults))
    }
    return result
}

// --- ДОБАВЛЯЕМ ОДИНОЧНЫЕ УПРАЖНЕНИЯ ДЛЯ ПРИМЕРА ---
func makeRegularInstance(exIndex: Int, reps: [Int], weights: [Double]) -> ExerciseInstance {
    let ex = exercisesCatalog[exIndex]
    let approaches = zip(reps, weights).map { (rep, weight) in
        Approach(
            set: ExerciseSet(
                id: UUID(),
                metricValues: [.reps: Double(rep), .weight: weight],
                notes: nil
            ),
            drops: []
        )
    }
    return ExerciseInstance(
        id: UUID(),
        exercise: ex,
        approaches: approaches,
        groupId: nil,
        notes: nil
    )
}

struct MockData {
    static var complexMockSessions: [WorkoutSession] {
        var sessionsWithDropAndSuper: [WorkoutSession] = mockSessions
        
        let superSetGroupId = UUID()
        let superSetGroup = SetGroup(
            id: superSetGroupId,
            type: .superset,
            exerciseInstanceIds: [superSetInstance1.id, superSetInstance2.id],
            repeatCount: 3
        )

        let dropSetGroupId = UUID()
        let dropSetGroup = SetGroup(
            id: dropSetGroupId,
            type: .dropset,
            exerciseInstanceIds: [dropSetInstance.id],
            repeatCount: 1
        )
        
        // Добавим новую сессию с дропсетом и суперсетом:
        sessionsWithDropAndSuper.append(
            WorkoutSession(
                id: UUID(),
                clientId: clientsMock[0].id,
                title: "Дропсет + Суперсет (пример)",
                date: ISO8601DateFormatter().date(from: "2025-05-30T18:00:00+03:00"),
                exerciseInstances: [
                    makeRegularInstance(exIndex: 3, reps: [12,10,9], weights: [0,0,0]), // Подтягивания (без веса)
                    dropSetInstance,
                    makeRegularInstance(exIndex: 1, reps: [8,12,10], weights: [30,40,50]), // Становая тяга
                    superSetInstance1,
                    superSetInstance2,
                    makeRegularInstance(exIndex: 2, reps: [10,9,8], weights: [30,40,45]) // Приседания со штангой
                ],
                setGroups: [dropSetGroup, superSetGroup],
                notes: "Тест дропсета и суперсета",
                status: .planned
            )
        )
        
        // Для наглядности можно добавить похожий пример в сессию другого клиента.
        sessionsWithDropAndSuper.append(
            WorkoutSession(
                id: UUID(),
                clientId: clientsMock[3].id,
                title: "Fullbody: суперсет и дропсет",
                date: ISO8601DateFormatter().date(from: "2025-06-02T19:00:00+03:00"),
                exerciseInstances: [
                    dropSetInstance,
                    superSetInstance1,
                    superSetInstance2
                ],
                setGroups: [dropSetGroup, superSetGroup],
                notes: "Микс для продвинутых",
                status: .planned
            )
        )
        return sessionsWithDropAndSuper
    }
}
