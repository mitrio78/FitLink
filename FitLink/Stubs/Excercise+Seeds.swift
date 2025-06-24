////
////  Excercise+Seeds.swift
////  FitLink
////
////  Created by Дмитрий Гришечко on 29.05.2025.
////
import Foundation

let exercisesCatalog: [Exercise] = [
    Exercise(
        id: UUID(),
        name: "Жим лёжа",
        description: "Классическое упражнение для тренировки грудных мышц, трицепса и передних дельт.",
        mediaURL: nil,
        variations: ["Классический", "Наклонная скамья", "Узкий хват"],
        muscleGroups: [.chest, .triceps, .shoulders],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true),
            ExerciseMetric(type: .weight, unit: .kg, isRequired: false)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Становая тяга",
        description: "Многоставное базовое упражнение для спины, ягодиц и ног.",
        mediaURL: nil,
        variations: ["Классическая", "Сумо", "Румынская"],
        muscleGroups: [.back, .legs, .glutes, .forearms],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true),
            ExerciseMetric(type: .weight, unit: .kg, isRequired: false)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Приседания со штангой",
        description: "Одно из самых эффективных упражнений для развития ног и ягодиц.",
        mediaURL: nil,
        variations: ["Классические", "Фронтальные", "С широкой постановкой ног"],
        muscleGroups: [.legs, .glutes, .core],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true),
            ExerciseMetric(type: .weight, unit: .kg, isRequired: false)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Подтягивания",
        description: "Отлично развивает широчайшие мышцы спины и бицепсы.",
        mediaURL: nil,
        variations: ["Обычные", "Обратным хватом", "Широким хватом"],
        muscleGroups: [.back, .biceps, .forearms],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Отжимания на брусьях",
        description: "Развивает грудные мышцы, трицепс и передние дельты.",
        mediaURL: nil,
        variations: ["Грудные", "Трицепсовые"],
        muscleGroups: [.chest, .triceps, .shoulders],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Жим гантелей стоя",
        description: "Развивает плечи и трицепсы.",
        mediaURL: nil,
        variations: ["Сидя", "Стоя"],
        muscleGroups: [.shoulders, .triceps],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true),
            ExerciseMetric(type: .weight, unit: .kg, isRequired: false)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Сгибания рук с гантелями",
        description: "Изолированно нагружает бицепсы.",
        mediaURL: nil,
        variations: ["Стоя", "Супинированным хватом", "Молотковые"],
        muscleGroups: [.biceps, .forearms],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true),
            ExerciseMetric(type: .weight, unit: .kg, isRequired: false)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Разгибания рук на блоке",
        description: "Изоляция трицепса.",
        mediaURL: nil,
        variations: ["Верёвочная рукоять", "Прямая рукоять"],
        muscleGroups: [.triceps],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true),
            ExerciseMetric(type: .weight, unit: .kg, isRequired: false)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Планка",
        description: "Удержание корпуса в прямой линии. Отлично развивает кор и стабилизаторы.",
        mediaURL: nil,
        variations: ["На локтях", "Боковая", "С поднятой ногой"],
        muscleGroups: [.core, .abs],
        metrics: [
            ExerciseMetric(type: .time, unit: .sec, isRequired: true)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Скручивания на пресс",
        description: "Изоляция прямых мышц живота.",
        mediaURL: nil,
        variations: ["Обычные", "С поднятыми ногами", "На скамье"],
        muscleGroups: [.abs],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Выпады",
        description: "Развивают мышцы ног и ягодиц.",
        mediaURL: nil,
        variations: ["Классические", "С гантелями", "Назад"],
        muscleGroups: [.legs, .glutes],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true),
            ExerciseMetric(type: .weight, unit: .kg, isRequired: false)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Гиперэкстензия",
        description: "Укрепляет разгибатели спины и ягодицы.",
        mediaURL: nil,
        variations: ["На скамье", "С весом"],
        muscleGroups: [.back, .glutes, .core],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Махи гантелями в стороны",
        description: "Изоляция средних дельт.",
        mediaURL: nil,
        variations: ["Сидя", "Стоя"],
        muscleGroups: [.shoulders],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true),
            ExerciseMetric(type: .weight, unit: .kg, isRequired: false)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Тяга штанги в наклоне",
        description: "Развивает широчайшие мышцы спины и бицепсы.",
        mediaURL: nil,
        variations: ["Классика", "Обратным хватом"],
        muscleGroups: [.back, .biceps],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true),
            ExerciseMetric(type: .weight, unit: .kg, isRequired: false)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Тяга верхнего блока",
        description: "Альтернатива подтягиваниям, удобно для прогрессии.",
        mediaURL: nil,
        variations: ["К груди", "За голову"],
        muscleGroups: [.back, .biceps],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true),
            ExerciseMetric(type: .weight, unit: .kg, isRequired: false)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Подъёмы на икры",
        description: "Изолированная нагрузка на икроножные.",
        mediaURL: nil,
        variations: ["Стоя", "Сидя"],
        muscleGroups: [.calves],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Отжимания от пола",
        description: "Доступное упражнение на грудные, плечи, трицепс.",
        mediaURL: nil,
        variations: ["Обычные", "Узким хватом", "Широким хватом"],
        muscleGroups: [.chest, .shoulders, .triceps],
        metrics: [
            ExerciseMetric(type: .reps, unit: .reps, isRequired: true)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Кардио: бег на дорожке",
        description: "Кардио-нагрузка на выносливость и жиросжигание.",
        mediaURL: nil,
        variations: ["Быстрый бег", "Интервальный бег"],
        muscleGroups: [.cardio, .legs, .fullBody],
        metrics: [
            ExerciseMetric(type: .time, unit: .sec, isRequired: true),
            ExerciseMetric(type: .distance, unit: nil, isRequired: false)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Скакалка",
        description: "Развивает выносливость, ноги и координацию.",
        mediaURL: nil,
        variations: ["Двойные", "Скоростные"],
        muscleGroups: [.cardio, .legs, .fullBody],
        metrics: [
            ExerciseMetric(type: .time, unit: .sec, isRequired: true)
        ]
    ),
    Exercise(
        id: UUID(),
        name: "Растяжка стоя",
        description: "Для гибкости, профилактики травм и завершения тренировки.",
        mediaURL: nil,
        variations: ["На ноги", "На спину"],
        muscleGroups: [.mobility, .legs, .back],
        metrics: [
            ExerciseMetric(type: .time, unit: .sec, isRequired: true)
        ]
    )
]
