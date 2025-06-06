//
//  WorkoutSession.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//

import Foundation
import SwiftUI

struct WorkoutSession: Identifiable, Codable, Hashable {
    let id: UUID
    let clientId: UUID?
    var title: String
    var date: Date?
    var exerciseInstances: [ExerciseInstance]
    var setGroups: [SetGroup]?
    var notes: String?
    let status: SessionStatus

    var dateString: String {
        guard let date else { return "" }
        return DateFormatterService.shared.formattedDate(date)
    }

    var timeString: String {
        guard let date else { return "" }
        return DateFormatterService.shared.formattedTime(date)
    }
}

enum SessionStatus: String, Codable, CaseIterable, Hashable {
    case planned = "Запланирована"
    case inProgress = "В процессе"
    case completed = "Выполнена"
    case cancelled = "Отменена"

    var labelText: String {
        switch self {
        case .planned:
            return NSLocalizedString("SessionStatus.PlannedLabel", comment: "Запланировано")
        case .inProgress:
            return NSLocalizedString("SessionStatus.InProgressLabel", comment: "В процессе")
        case .completed:
            return NSLocalizedString("SessionStatus.CompletedLabel", comment: "Выполнено")
        case .cancelled:
            return NSLocalizedString("SessionStatus.CancelledLabel", comment: "Отменено")
        }
    }
    
    var iconName: String {
        switch self {
        case .planned: return "calendar"
        case .inProgress: return "bolt.fill"
        case .completed: return "checkmark.circle.fill"
        case .cancelled: return "xmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .planned: return .blue
        case .inProgress: return .orange
        case .completed: return .green
        case .cancelled: return .red
        }
    }
    
    /// Для фонового цвета капсулы-лейбла
    var backgroundColor: Color {
        color.opacity(0.12)
    }
}
