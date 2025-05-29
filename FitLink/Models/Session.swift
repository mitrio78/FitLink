//
//  Session.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import Foundation
import SwiftUI

enum SessionStatus: String, CaseIterable {
    case pending = "Pending"
    case completed = "Completed"
    case cancelled = "Cancelled"
    
    var color: Color {
        switch self {
        case .pending: return .orange
        case .completed: return .green
        case .cancelled: return .red
        }
    }
}

struct Session: Identifiable {
    let id = UUID()
    let clientName: String
    let clientAvatar: String? // system image name или url, для моков — имя изображения
    let workoutTitle: String
    let date: Date
    let time: String // для простоты, например "10:30 AM"
    let status: SessionStatus
}

extension Session {
    static let mockData: [Session] = [
        // 7 тренировок на 15 мая 2025
        Session(
            clientName: "Клиент 1",
            clientAvatar: "person.circle",
            workoutTitle: "Кардио",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 15, hour: 9, minute: 0))!,
            time: "09:00",
            status: .completed
        ),
        Session(
            clientName: "Клиент 2",
            clientAvatar: "person.fill",
            workoutTitle: "Силовая",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 15, hour: 10, minute: 0))!,
            time: "10:00",
            status: .pending
        ),
        Session(
            clientName: "Клиент 3",
            clientAvatar: "person.crop.circle.badge.checkmark",
            workoutTitle: "HIIT",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 15, hour: 11, minute: 0))!,
            time: "11:00",
            status: .cancelled
        ),
        Session(
            clientName: "Клиент 4",
            clientAvatar: "person.circle",
            workoutTitle: "Стретчинг",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 15, hour: 12, minute: 0))!,
            time: "12:00",
            status: .completed
        ),
        Session(
            clientName: "Клиент 5",
            clientAvatar: "person.fill",
            workoutTitle: "Мобилити",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 15, hour: 13, minute: 0))!,
            time: "13:00",
            status: .pending
        ),
        Session(
            clientName: "Клиент 6",
            clientAvatar: "person.crop.circle.badge.checkmark",
            workoutTitle: "Функциональный тренинг",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 15, hour: 14, minute: 0))!,
            time: "14:00",
            status: .completed
        ),
        Session(
            clientName: "Клиент 7",
            clientAvatar: "person.circle",
            workoutTitle: "Групповая тренировка",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 15, hour: 15, minute: 0))!,
            time: "15:00",
            status: .completed
        ),
        // Ещё несколько дней для полноты картины:
        Session(
            clientName: "Максим Орлов",
            clientAvatar: "person.circle",
            workoutTitle: "Стретчинг",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 7, hour: 11, minute: 45))!,
            time: "11:45",
            status: .completed
        ),
        Session(
            clientName: "Анна Кузнецова",
            clientAvatar: "person.crop.circle.badge.checkmark",
            workoutTitle: "Кардио",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 8, hour: 18, minute: 30))!,
            time: "18:30",
            status: .pending
        ),
        Session(
            clientName: "Наталья Соколова",
            clientAvatar: "person.fill",
            workoutTitle: "Мобилити",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 20, hour: 16, minute: 30))!,
            time: "16:30",
            status: .pending
        ),
        Session(
            clientName: "Алексей Жуков",
            clientAvatar: "person.circle",
            workoutTitle: "Групповая тренировка",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 2, hour: 18, minute: 0))!,
            time: "18:00",
            status: .completed
        ),
        Session(
            clientName: "Виктория Морозова",
            clientAvatar: "person.crop.circle.badge.checkmark",
            workoutTitle: "Йога",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 3, hour: 8, minute: 30))!,
            time: "08:30",
            status: .completed
        ),
        Session(
            clientName: "Павел Васильев",
            clientAvatar: "person.fill",
            workoutTitle: "Персональная тренировка",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 5, hour: 13, minute: 0))!,
            time: "13:00",
            status: .pending
        ),
        Session(
            clientName: "Сергей Петров",
            clientAvatar: "person.circle",
            workoutTitle: "Силовая тренировка",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 7, hour: 10, minute: 0))!,
            time: "10:00",
            status: .completed
        ),
        Session(
            clientName: "Анна Кузнецова",
            clientAvatar: "person.crop.circle.fill",
            workoutTitle: "Кардио",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 8, hour: 18, minute: 30))!,
            time: "18:30",
            status: .pending
        ),
        Session(
            clientName: "Дмитрий Иванов",
            clientAvatar: "person.fill",
            workoutTitle: "HIIT-тренировка",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 9, hour: 9, minute: 15))!,
            time: "09:15",
            status: .completed
        ),
        Session(
            clientName: "Екатерина Смирнова",
            clientAvatar: "person.crop.circle.badge.checkmark",
            workoutTitle: "Функциональный тренинг",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 12, hour: 17, minute: 0))!,
            time: "17:00",
            status: .pending
        ),
        Session(
            clientName: "Максим Орлов",
            clientAvatar: "person.circle",
            workoutTitle: "Стретчинг",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 15, hour: 11, minute: 45))!,
            time: "11:45",
            status: .completed
        ),
        Session(
            clientName: "Наталья Соколова",
            clientAvatar: "person.crop.circle.fill",
            workoutTitle: "Мобилити",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 20, hour: 16, minute: 30))!,
            time: "16:30",
            status: .pending
        ),
        Session(
            clientName: "Алексей Жуков",
            clientAvatar: "person.fill",
            workoutTitle: "Групповая тренировка",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 2, hour: 18, minute: 0))!,
            time: "18:00",
            status: .completed
        ),
        Session(
            clientName: "Виктория Морозова",
            clientAvatar: "person.crop.circle.badge.checkmark",
            workoutTitle: "Йога",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 3, hour: 8, minute: 30))!,
            time: "08:30",
            status: .completed
        ),
        Session(
            clientName: "Павел Васильев",
            clientAvatar: "person.circle",
            workoutTitle: "Персональная тренировка",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 5, hour: 13, minute: 0))!,
            time: "13:00",
            status: .pending
        ),
        Session(
            clientName: "Ирина Ковалева",
            clientAvatar: "person.crop.circle.fill",
            workoutTitle: "Силовой круг",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 6, hour: 19, minute: 0))!,
            time: "19:00",
            status: .completed
        ),
        Session(
            clientName: "Глеб Николаев",
            clientAvatar: "person.fill",
            workoutTitle: "Кроссфит",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 8, hour: 10, minute: 30))!,
            time: "10:30",
            status: .pending
        ),
        Session(
            clientName: "Ольга Лебедева",
            clientAvatar: "person.crop.circle.badge.checkmark",
            workoutTitle: "Пилатес",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 10, hour: 9, minute: 0))!,
            time: "09:00",
            status: .completed
        ),
        Session(
            clientName: "Иван Сергеев",
            clientAvatar: "person.circle",
            workoutTitle: "Кардио-интервалы",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 13, hour: 15, minute: 15))!,
            time: "15:15",
            status: .pending
        ),
        Session(
            clientName: "Алиса Попова",
            clientAvatar: "person.crop.circle.fill",
            workoutTitle: "Зумба",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 17, hour: 18, minute: 30))!,
            time: "18:30",
            status: .completed
        ),
        Session(
            clientName: "Руслан Федоров",
            clientAvatar: "person.fill",
            workoutTitle: "Stretch & Relax",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 19, hour: 20, minute: 0))!,
            time: "20:00",
            status: .pending
        ),
        Session(
            clientName: "Мария Синицына",
            clientAvatar: "person.crop.circle.badge.checkmark",
            workoutTitle: "Плиометрика",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 22, hour: 17, minute: 45))!,
            time: "17:45",
            status: .completed
        ),
        Session(
            clientName: "Олег Киселёв",
            clientAvatar: "person.circle",
            workoutTitle: "Лёгкая разминка",
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 25, hour: 8, minute: 0))!,
            time: "08:00",
            status: .pending
        )
    ]
}
