//
//  Untitled.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 30.05.2025.
//
import Foundation
import SwiftUI

enum MuscleGroup: Codable, Equatable, Hashable {
    case chest
    case back
    case shoulders
    case biceps
    case triceps
    case legs
    case glutes
    case abs
    case core
    case calves
    case forearms
    case traps
    case cardio
    case mobility
    case fullBody
    case custom(String)

    var displayName: String {
        switch self {
        case .chest: return "Грудные"
        case .back: return "Спина"
        case .shoulders: return "Плечи"
        case .biceps: return "Бицепс"
        case .triceps: return "Трицепс"
        case .legs: return "Ноги"
        case .glutes: return "Ягодицы"
        case .abs: return "Пресс"
        case .core: return "Кор"
        case .calves: return "Икры"
        case .forearms: return "Предплечья"
        case .traps: return "Трапеции"
        case .cardio: return "Кардио"
        case .mobility: return "Мобильность"
        case .fullBody: return "Всё тело"
        case .custom(let value): return value
        }
    }

    static var allStandardCases: [MuscleGroup] {
        [.chest, .back, .shoulders, .biceps, .triceps, .legs, .glutes, .abs, .core, .calves, .forearms, .traps, .cardio, .mobility, .fullBody]
    }

    var iconName: String {
        switch self {
        case .chest: return "figure.strengthtraining.traditional"
        case .back: return "figure.strengthtraining.traditional"
        case .shoulders: return "figure.strengthtraining.functional"
        case .biceps, .triceps, .forearms: return "dumbbell"
        case .legs, .calves: return "figure.run"
        case .glutes: return "figure.walk"
        case .abs, .core: return "figure.core.training"
        case .traps: return "triangle"
        case .cardio: return "heart.fill"
        case .mobility: return "figure.cooldown"
        case .fullBody: return "figure.mixed.cardio"
        case .custom: return "star"
        }
    }

    var color: Color {
        switch self {
        case .chest: return .pink
        case .back: return .blue
        case .shoulders: return .orange
        case .biceps: return .indigo
        case .triceps: return .purple
        case .legs: return .green
        case .glutes: return .brown
        case .abs: return .yellow
        case .core: return .purple
        case .calves: return .teal
        case .forearms: return .mint
        case .traps: return .cyan
        case .cardio: return .red
        case .mobility: return .mint
        case .fullBody: return .gray
        case .custom: return .gray
        }
    }
}
