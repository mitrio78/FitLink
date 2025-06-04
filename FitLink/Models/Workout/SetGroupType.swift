//
//  SetGroupType.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 30.05.2025.
//
import Foundation
import SwiftUI

/// Группировка упражнений
enum SetGroupType: Codable, Equatable, Hashable {
    case superset
    case dropset
    case circuit
    case pyramid
    case custom(String)

    var displayName: String {
        switch self {
        case .superset:
            return NSLocalizedString("SetGroupType.Superset", comment: "Суперсет")
        case .dropset:
            return NSLocalizedString("SetGroupType.Dropset", comment: "Дропсет")
        case .circuit:
            return NSLocalizedString("SetGroupType.Circuit", comment: "Круг")
        case .pyramid:
            return NSLocalizedString("SetGroupType.Pyramid", comment: "Пирамида")
        case .custom(let value):
            return value
        }
    }

    var iconName: String {
        switch self {
        case .superset: return "arrow.triangle.2.circlepath"
        case .dropset: return "arrow.down.to.line"
        case .circuit: return "repeat.circle"
        case .pyramid: return "triangle.fill"
        case .custom: return "sparkle"
        }
    }

    var color: Color {
        switch self {
        case .superset: return .blue
        case .dropset: return .orange
        case .circuit: return .purple
        case .pyramid: return .mint
        case .custom: return .gray
        }
    }
}

struct SetGroup: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var type: SetGroupType
    var exerciseInstanceIds: [UUID]   // id тех ExerciseInstance, которые входят в группу
    var repeatCount: Int?             // Для круговых, если нужно повторять группу несколько раз
    var notes: String?
}

struct SuperSetApproach {
    let id = UUID()
    let sets: [ExerciseSet] // порядок: [упражнение 1, упражнение 2, ...]
}

struct DropSetApproach {
    let id = UUID()
    let steps: [ExerciseSet] // Ступени дропа: основной, дроп1, дроп2...
}
