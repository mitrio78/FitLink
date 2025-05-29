//
//  ExcerciseCategory.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//

import Foundation
import SwiftUI

enum ExerciseCategory: String, CaseIterable, Identifiable, Codable {
    case chest = "Грудные"
    case back = "Спина"
    case legs = "Ноги"
    case arms = "Руки"
    case shoulders = "Плечи"
    case core = "Пресс"
    case cardio = "Кардио"
    case mobility = "Мобилити"
    case fullBody = "Всё тело"
    case other = "Другое"

    var id: String { self.rawValue }

    var iconName: String {
        switch self {
        case .chest: return "figure.strengthtraining.traditional"
        case .back: return "figure.strengthtraining.traditional" // Было "figure.pullup" — заменили!
        case .legs: return "figure.run"
        case .arms: return "dumbbell"
        case .shoulders: return "figure.strengthtraining.functional"
        case .core: return "figure.core.training"
        case .cardio: return "heart.fill"
        case .mobility: return "figure.cooldown"
        case .fullBody: return "figure.mixed.cardio"
        case .other: return "star"
        }
    }
    
    var color: Color {
        switch self {
        case .chest: return .pink
        case .back: return .blue
        case .legs: return .green
        case .arms: return .indigo
        case .shoulders: return .orange
        case .core: return .purple
        case .cardio: return .red
        case .mobility: return .mint
        case .fullBody: return .teal
        case .other: return .gray
        }
    }

}
