//
//  Session.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import Foundation
import SwiftUI

enum SessionStatus: String, CaseIterable {
    case planned = "Запланирована"
    case inProgress = "Идёт"
    case completed = "Выполнена"
    case cancelled = "Отменена"
    
    var color: Color {
        switch self {
        case .planned: return .blue
        case .inProgress: return .orange
        case .completed: return .green
        case .cancelled: return .red
        }
    }
}

struct Session: Identifiable {
    let id = UUID()
    let clientId: UUID
    let clientName: String
    let clientAvatar: String? // system image name или url, для моков — имя изображения
    let workoutTitle: String
    let date: Date
    let time: String // например "10:30 AM"
    let status: SessionStatus
}
