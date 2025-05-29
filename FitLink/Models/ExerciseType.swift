//
//  ExerciseType.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import Foundation

enum ExerciseType: String, CaseIterable, Identifiable {
    case strength = "Strength"
    case cardio = "Cardio"
    case mobility = "Mobility"
    case circuit = "Circuit"
    case custom = "Custom"

    var id: String { rawValue }
    var iconName: String {
        switch self {
        case .strength: return "figure.strengthtraining.traditional"
        case .cardio: return "figure.run"
        case .mobility: return "figure.cooldown"
        case .circuit: return "rectangle.3.group"
        case .custom: return "star"
        }
    }
}

enum ExerciseVariation: String, CaseIterable, Identifiable {
    case none = "Standard"
    case superset = "Superset"
    case dropset = "Drop Set"
    case triset = "Tri-set"
    case circuit = "Circuit"
    var id: String { rawValue }
}

struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let type: ExerciseType
    let muscleGroup: String
    let equipment: String
    let thumbnailName: String? // для SFSymbols или local image
    let description: String
    let variations: [ExerciseVariation]
}

extension Exercise {
    static let mockData: [Exercise] = [
        Exercise(
            name: "Жим штанги лёжа",
            type: .strength,
            muscleGroup: "Грудь",
            equipment: "Штанга",
            thumbnailName: "figure.strengthtraining.traditional",
            description: "Базовое упражнение для развития грудных мышц и трицепсов.",
            variations: [.none, .superset]
        ),
        Exercise(
            name: "Тяга верхнего блока",
            type: .strength,
            muscleGroup: "Спина",
            equipment: "Блочный тренажёр",
            thumbnailName: "arrow.down.left.and.arrow.up.right",
            description: "Изолированное упражнение для широчайших мышц спины.",
            variations: [.none, .dropset]
        ),
        Exercise(
            name: "Приседания с гантелями",
            type: .strength,
            muscleGroup: "Ноги",
            equipment: "Гантели",
            thumbnailName: "figure.strengthtraining.functional",
            description: "Эффективное упражнение для проработки ягодиц и квадрицепсов.",
            variations: [.none]
        ),
        Exercise(
            name: "Разведение гантелей в стороны",
            type: .strength,
            muscleGroup: "Плечи",
            equipment: "Гантели",
            thumbnailName: "figure.strengthtraining.functional",
            description: "Изолированное упражнение для средних дельт.",
            variations: [.none, .superset]
        ),
        Exercise(
            name: "Подъем на бицепс",
            type: .strength,
            muscleGroup: "Руки",
            equipment: "Гантели",
            thumbnailName: "figure.flexibility",
            description: "Классическое упражнение для проработки бицепсов.",
            variations: [.none, .dropset]
        ),
        Exercise(
            name: "Планка",
            type: .mobility,
            muscleGroup: "Кор",
            equipment: "Без оборудования",
            thumbnailName: "figure.cooldown",
            description: "Статическое упражнение для укрепления мышц корпуса.",
            variations: [.none]
        ),
        Exercise(
            name: "Бёрпи",
            type: .cardio,
            muscleGroup: "Всё тело",
            equipment: "Без оборудования",
            thumbnailName: "figure.run",
            description: "Интенсивное упражнение для развития выносливости и силы.",
            variations: [.none, .circuit]
        ),
        Exercise(
            name: "Скручивания на пресс",
            type: .strength,
            muscleGroup: "Пресс",
            equipment: "Коврик",
            thumbnailName: "figure.core.training",
            description: "Упражнение для прямых мышц живота.",
            variations: [.none]
        ),
        Exercise(
            name: "Махи гирей",
            type: .cardio,
            muscleGroup: "Ноги и спина",
            equipment: "Гиря",
            thumbnailName: "figure.strengthtraining.traditional",
            description: "Динамичное упражнение для взрывной силы и сердечно-сосудистой системы.",
            variations: [.none, .circuit]
        ),
        Exercise(
            name: "Отжимания на брусьях",
            type: .strength,
            muscleGroup: "Грудь и трицепс",
            equipment: "Брусья",
            thumbnailName: "figure.flexibility",
            description: "Продвинутое упражнение для развития грудных и трицепсов.",
            variations: [.none, .superset]
        ),
        Exercise(
            name: "Выпады вперёд",
            type: .strength,
            muscleGroup: "Ноги",
            equipment: "Гантели",
            thumbnailName: "figure.strengthtraining.functional",
            description: "Комплексное упражнение для ягодиц и квадрицепсов.",
            variations: [.none]
        ),
        Exercise(
            name: "Прыжки через скакалку",
            type: .cardio,
            muscleGroup: "Всё тело",
            equipment: "Скакалка",
            thumbnailName: "figure.run",
            description: "Кардио упражнение для сжигания калорий.",
            variations: [.none, .circuit]
        ),
        Exercise(
            name: "Разгибание ног в тренажёре",
            type: .strength,
            muscleGroup: "Квадрицепсы",
            equipment: "Тренажёр",
            thumbnailName: "figure.strengthtraining.traditional",
            description: "Изолированное упражнение для передней поверхности бедра.",
            variations: [.none, .dropset]
        ),
        Exercise(
            name: "Гиперэкстензия",
            type: .mobility,
            muscleGroup: "Спина",
            equipment: "Гиперэкстензия",
            thumbnailName: "figure.cooldown",
            description: "Укрепляет разгибатели спины и ягодичные.",
            variations: [.none]
        ),
        Exercise(
            name: "Подтягивания",
            type: .strength,
            muscleGroup: "Спина и руки",
            equipment: "Турник",
            thumbnailName: "arrow.up.and.down",
            description: "Классика для развития широчайших и бицепса.",
            variations: [.none, .superset, .dropset]
        ),
        Exercise(
            name: "Тяга в наклоне",
            type: .strength,
            muscleGroup: "Спина",
            equipment: "Штанга",
            thumbnailName: "figure.strengthtraining.traditional",
            description: "Базовое упражнение для массы спины.",
            variations: [.none, .superset]
        ),
        Exercise(
            name: "Разгибание рук на блоке",
            type: .strength,
            muscleGroup: "Трицепс",
            equipment: "Кроссовер",
            thumbnailName: "figure.flexibility",
            description: "Изоляция для трицепсов.",
            variations: [.none]
        ),
        Exercise(
            name: "Глубокие приседания",
            type: .strength,
            muscleGroup: "Ягодицы и квадрицепсы",
            equipment: "Штанга",
            thumbnailName: "figure.strengthtraining.traditional",
            description: "Усложнённый вариант классических приседаний.",
            variations: [.none, .triset]
        ),
        Exercise(
            name: "Мостик",
            type: .mobility,
            muscleGroup: "Кор",
            equipment: "Коврик",
            thumbnailName: "figure.cooldown",
            description: "Упражнение для укрепления мышц спины и ягодиц.",
            variations: [.none]
        ),
        Exercise(
            name: "Жим ногами в тренажёре",
            type: .strength,
            muscleGroup: "Ноги",
            equipment: "Тренажёр",
            thumbnailName: "figure.strengthtraining.traditional",
            description: "Тяжёлое базовое для квадрицепсов и ягодиц.",
            variations: [.none, .dropset, .circuit]
        )
    ]
}
