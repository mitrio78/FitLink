//
//  ExerciseType.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import Foundation


struct Exercise: Identifiable, Hashable {
    let id: UUID
    let name: String
    let category: ExerciseCategory
    let defaultMeasurement: MeasurementType
    let description: String?
    let variations: [ExerciseVariation] // Например: "узким хватом", "наклонная", "разведение" и т.д.
}

enum MeasurementType: String, Codable {
    case reps      // количество повторов
    case time      // время
    case distance  // расстояние
    case weight    // вес
}

struct ExerciseVariation: Identifiable, Hashable {
    let id: UUID
    let name: String    // "Суперсет", "Дропсет", "Изометрия", "Медленный эксцентрик", и т.д.
    let details: String? // описание, если нужно
}

//enum ExerciseType: String, CaseIterable, Identifiable {
//    case strength = "Strength"
//    case cardio = "Cardio"
//    case mobility = "Mobility"
//    case circuit = "Circuit"
//    case custom = "Custom"
//
//    var id: String { rawValue }
//    var iconName: String {
//        switch self {
//        case .strength: return "figure.strengthtraining.traditional"
//        case .cardio: return "figure.run"
//        case .mobility: return "figure.cooldown"
//        case .circuit: return "rectangle.3.group"
//        case .custom: return "star"
//        }
//    }
//}
//
//enum ExerciseVariation: String, CaseIterable, Identifiable {
//    case none = "Standard"
//    case superset = "Superset"
//    case dropset = "Drop Set"
//    case triset = "Tri-set"
//    case circuit = "Circuit"
//    var id: String { rawValue }
//}
//
//struct Exercise: Identifiable {
//    let id = UUID()
//    let name: String
//    let type: ExerciseType
//    let muscleGroup: String
//    let equipment: String
//    let thumbnailName: String? // для SFSymbols или local image
//    let description: String
//    let variations: [ExerciseVariation]
//}
