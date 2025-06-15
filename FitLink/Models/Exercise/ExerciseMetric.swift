//
//  ExerciseMetric.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 30.05.2025.
//

import Foundation

/// Описание метрики для конкретного упражнения
struct ExerciseMetric: Codable, Equatable, Hashable {
    var type: ExerciseMetricType
    var unit: UnitType?
    var isRequired: Bool

    var displayName: String {
        type.displayName
    }
    
    var iconName: String? {
        type.iconName
    }
    
    static func formattedMetric(_ value: Double, metric: ExerciseMetric) -> String {
        let intValue = value == floor(value) ? String(Int(value)) : String(format: "%.1f", value)
        if metric.type == .reps, let unit = metric.unit?.displayName, !unit.isEmpty {
            return " \(unit) \(intValue)"
        } else if let unit = metric.unit?.displayName, !unit.isEmpty {
            return "\(intValue) \(unit)"
        }
        return intValue
    }
}

/// Типы метрик упражнения
enum ExerciseMetricType: Codable, CaseIterable, Equatable, Hashable {
    case reps
    case weight
    case time
    case distance
    case calories
    case custom(String)

    var displayName: String {
        switch self {
        case .reps:
            return NSLocalizedString("ExerciseMetricType.Reps", comment: "Повторы")
        case .weight:
            return NSLocalizedString("ExerciseMetricType.Weight", comment: "Вес")
        case .time:
            return NSLocalizedString("ExerciseMetricType.Time", comment: "Время")
        case .distance:
            return NSLocalizedString("ExerciseMetricType.Distance", comment: "Дистанция")
        case .calories:
            return NSLocalizedString("ExerciseMetricType.Calories", comment: "Калории")
        case .custom(let value):
            return value
        }
    }
    
    /// Имя иконки SF Symbols для типа метрики
    var iconName: String? {
        switch self {
        case .reps: return "repeat"
        case .weight: return "scalemass"
        case .time: return "timer"
        case .distance: return "ruler"
        case .calories: return "flame"
        case .custom:
            return nil // Или придумать дефолтную, если нужно
        }
    }
    
    static var allCases: [ExerciseMetricType] {
        return [.reps, .weight, .time, .distance, .calories]
    }
}

/// Типы единиц измерения
enum UnitType: Codable, CaseIterable, Equatable, Hashable {
    case kilogram
    case pound
    case second
    case minute
    case meter
    case kilometer
    case repetition
    case calorie
    case custom(String)

    var displayName: String {
        switch self {
        case .kilogram:
            return NSLocalizedString("UnitType.Kilogram", comment: "кг")
        case .pound:
            return NSLocalizedString("UnitType.Pound", comment: "фунты")
        case .second:
            return NSLocalizedString("UnitType.Second", comment: "сек")
        case .minute:
            return NSLocalizedString("UnitType.Minute", comment: "мин")
        case .meter:
            return NSLocalizedString("UnitType.Meter", comment: "м")
        case .kilometer:
            return NSLocalizedString("UnitType.Kilometer", comment: "км")
        case .repetition:
            return NSLocalizedString("UnitType.Repetition", comment: "повт.")
        case .calorie:
            return NSLocalizedString("UnitType.Calorie", comment: "ккал")
        case .custom(let value):
            return value
        }
    }
    
    static var allCases: [UnitType] {
        return [.kilogram, .pound, .second, .minute, .meter, .kilometer, .repetition, .calorie]
    }
}
