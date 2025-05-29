//
//  ClientsViewModel.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import Foundation
import Combine

final class ScheduleViewModel: ObservableObject {
    @Published var sessions: [Session] = mockSessions
    @Published var searchText: String = ""
    @Published var selectedDate: Date = Date()
    @Published var isCalendarMode: Bool = true // переключатель режимов: календарь/список

    // Фильтрация по клиенту и дате
    var filteredSessions: [Session] {
        sessions.filter { session in
            (searchText.isEmpty || session.clientName.lowercased().contains(searchText.lowercased()))
            && Calendar.current.isDate(session.date, inSameDayAs: selectedDate)
        }
        .sorted(by: { $0.date < $1.date })
    }
    
    // Для списка всех (например, today's sessions)
    var todaySessions: [Session] {
        let today = Date()
        return sessions.filter {
            Calendar.current.isDate($0.date, inSameDayAs: today)
            && (searchText.isEmpty || $0.clientName.lowercased().contains(searchText.lowercased()))
        }
        .sorted(by: { $0.date < $1.date })
    }
}

extension ScheduleViewModel {
    var sessionsByDate: [Date: [Session]] {
        Dictionary(grouping: sessions) {
            Calendar.current.startOfDay(for: $0.date)
        }
    }
}
