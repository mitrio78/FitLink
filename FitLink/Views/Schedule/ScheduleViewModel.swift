//
//  ClientsViewModel.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//
import Foundation
import Combine

@MainActor
final class ScheduleViewModel: ObservableObject {
    @Published var sessions: [WorkoutSession]
    @Published var clients: [UUID: Client]
    @Published var searchText: String = ""
    @Published var selectedDate: Date = Date()
    @Published var isCalendarMode: Bool = true
    private let dataStore: AppDataStore

    init(dataStore: AppDataStore = .shared) {
        self.dataStore = dataStore
        self.sessions = dataStore.sessions
        self.clients = dataStore.clientsById
    }

    // Фильтрация по клиенту и дате
    var filteredSessions: [WorkoutSession] {
        sessions.filter { session in
            let clientName = session.clientId.flatMap { clients[$0]?.name } ?? ""
            let matchesSearch = searchText.isEmpty || clientName.lowercased().contains(searchText.lowercased())
            let matchesDate = session.date.map { Calendar.current.isDate($0, inSameDayAs: selectedDate) } ?? false
            return matchesSearch && matchesDate
        }
        .sorted {
            ($0.date ?? .distantPast) < ($1.date ?? .distantPast)
        }
    }

    // Для списка всех на сегодня
    var todaySessions: [WorkoutSession] {
        let today = Date()
        return sessions.filter { session in
            let clientName = session.clientId.flatMap { clients[$0]?.name } ?? ""
            let matchesSearch = searchText.isEmpty || clientName.lowercased().contains(searchText.lowercased())
            let matchesDate = session.date.map { Calendar.current.isDate($0, inSameDayAs: today) } ?? false
            return matchesSearch && matchesDate
        }
        .sorted {
            ($0.date ?? .distantPast) < ($1.date ?? .distantPast)
        }
    }
}

extension ScheduleViewModel {
    var sessionsByDate: [Date: [WorkoutSession]] {
        Dictionary(grouping: sessions.filter { $0.date != nil }) {
            Calendar.current.startOfDay(for: $0.date!)
        }
    }
}
