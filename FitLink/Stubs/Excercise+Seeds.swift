//
//  Excercise+Seeds.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//

import Foundation
extension Exercise {
    static let mockData: [Exercise] = [
        Exercise(
            id: UUID(),
            name: "Жим лёжа",
            category: .chest,
            defaultMeasurement: .weight,
            description: "Классический жим штанги лёжа на горизонтальной скамье.",
            variations: [
                ExerciseVariation(id: UUID(), name: "Гантели", details: "Жим гантелей лёжа"),
                ExerciseVariation(id: UUID(), name: "Наклонная скамья", details: "Жим штанги на наклонной скамье"),
                ExerciseVariation(id: UUID(), name: "Суперсет", details: "Выполнять в суперсете с разведением гантелей")
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Подтягивания",
            category: .back,
            defaultMeasurement: .reps,
            description: "Подтягивания широким или узким хватом на перекладине.",
            variations: [
                ExerciseVariation(id: UUID(), name: "Широкий хват", details: "Подтягивания широким хватом"),
                ExerciseVariation(id: UUID(), name: "Узкий хват", details: "Подтягивания узким хватом"),
                ExerciseVariation(id: UUID(), name: "Дроп-сет", details: "Снижение нагрузки после отказа")
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Приседания со штангой",
            category: .legs,
            defaultMeasurement: .weight,
            description: "Базовое упражнение для тренировки ног и ягодиц.",
            variations: [
                ExerciseVariation(id: UUID(), name: "Фронтальный присед", details: "Штанга на груди"),
                ExerciseVariation(id: UUID(), name: "Плие", details: "Широкая постановка ног"),
                ExerciseVariation(id: UUID(), name: "Суперсет", details: "Выполнять с выпадом назад")
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Становая тяга",
            category: .back,
            defaultMeasurement: .weight,
            description: "Развитие мышц спины и ног.",
            variations: [
                ExerciseVariation(id: UUID(), name: "Классическая", details: nil),
                ExerciseVariation(id: UUID(), name: "Румынская", details: "Больше акцент на бёдра"),
                ExerciseVariation(id: UUID(), name: "Сумо", details: "Широкая постановка ног")
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Жим ногами",
            category: .legs,
            defaultMeasurement: .weight,
            description: "Изолированное упражнение для квадрицепсов.",
            variations: [
                ExerciseVariation(id: UUID(), name: "Узкая постановка", details: nil),
                ExerciseVariation(id: UUID(), name: "Широкая постановка", details: nil)
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Разгибание ног в тренажёре",
            category: .legs,
            defaultMeasurement: .weight,
            description: "Изолированное упражнение для передней поверхности бедра.",
            variations: []
        ),
        Exercise(
            id: UUID(),
            name: "Сгибание ног лёжа",
            category: .legs,
            defaultMeasurement: .weight,
            description: "Тренировка бицепса бедра.",
            variations: [
                ExerciseVariation(id: UUID(), name: "Дроп-сет", details: "Постепенное снижение веса")
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Отжимания на брусьях",
            category: .arms,
            defaultMeasurement: .reps,
            description: "Тренировка трицепса и груди.",
            variations: [
                ExerciseVariation(id: UUID(), name: "С дополнительным весом", details: nil),
                ExerciseVariation(id: UUID(), name: "Суперсет", details: "Выполнять с французским жимом")
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Французский жим лёжа",
            category: .arms,
            defaultMeasurement: .weight,
            description: "Изолированное упражнение для трицепса.",
            variations: [
                ExerciseVariation(id: UUID(), name: "Гантели", details: "Две руки одновременно"),
                ExerciseVariation(id: UUID(), name: "Штанга EZ", details: "Удобный гриф для запястий")
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Бицепс со штангой стоя",
            category: .arms,
            defaultMeasurement: .weight,
            description: "Базовое упражнение для бицепса.",
            variations: [
                ExerciseVariation(id: UUID(), name: "Штанга EZ", details: "Супинированный хват"),
                ExerciseVariation(id: UUID(), name: "Суперсет", details: "Выполнять с отжиманиями")
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Тяга вертикального блока",
            category: .back,
            defaultMeasurement: .weight,
            description: "Тяга верхнего блока к груди.",
            variations: [
                ExerciseVariation(id: UUID(), name: "Обратный хват", details: nil),
                ExerciseVariation(id: UUID(), name: "Широкий хват", details: nil)
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Разведение гантелей в стороны",
            category: .shoulders,
            defaultMeasurement: .weight,
            description: "Изоляция средних дельт.",
            variations: [
                ExerciseVariation(id: UUID(), name: "В наклоне", details: nil),
                ExerciseVariation(id: UUID(), name: "Суперсет", details: "С жимом гантелей")
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Жим гантелей сидя",
            category: .shoulders,
            defaultMeasurement: .weight,
            description: "Базовое упражнение для плеч.",
            variations: [
                ExerciseVariation(id: UUID(), name: "Суперсет", details: "Выполнять с разводкой")
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Планка",
            category: .core,
            defaultMeasurement: .time,
            description: "Укрепление мышц кора.",
            variations: [
                ExerciseVariation(id: UUID(), name: "На локтях", details: nil),
                ExerciseVariation(id: UUID(), name: "С поднятой ногой", details: nil)
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Скручивания на пресс",
            category: .core,
            defaultMeasurement: .reps,
            description: "Классическое упражнение на пресс.",
            variations: []
        ),
        Exercise(
            id: UUID(),
            name: "Бёрпи",
            category: .fullBody,
            defaultMeasurement: .reps,
            description: "Функциональное упражнение для всего тела.",
            variations: [
                ExerciseVariation(id: UUID(), name: "С прыжком", details: nil),
                ExerciseVariation(id: UUID(), name: "Без отжимания", details: nil)
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Велотренажёр",
            category: .cardio,
            defaultMeasurement: .time,
            description: "Кардио тренировка для выносливости.",
            variations: []
        ),
        Exercise(
            id: UUID(),
            name: "Бег на дорожке",
            category: .cardio,
            defaultMeasurement: .distance,
            description: "Кардио упражнение для тренировки ног и сердца.",
            variations: [
                ExerciseVariation(id: UUID(), name: "Интервальный бег", details: "Чередование скоростей"),
                ExerciseVariation(id: UUID(), name: "Наклон", details: "С подъёмом дорожки")
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Мобилити для спины",
            category: .mobility,
            defaultMeasurement: .time,
            description: "Упражнения для гибкости и здоровья спины.",
            variations: [
                ExerciseVariation(id: UUID(), name: "Кошка-корова", details: nil),
                ExerciseVariation(id: UUID(), name: "Повороты лёжа", details: nil)
            ]
        ),
        Exercise(
            id: UUID(),
            name: "Растяжка на шпагат",
            category: .mobility,
            defaultMeasurement: .time,
            description: "Комплекс упражнений для развития гибкости.",
            variations: []
        ),
        // Добавь при желании ещё!
    ]
}
