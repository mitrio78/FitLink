//
//  DashboardViewModel.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import Foundation
import Combine

final class TrainerDashboardViewModel: ObservableObject {
    @Published var clients: [Client] = mockClients
    @Published var sessions: [Session] = mockSessions
    @Published var searchText: String = ""
    @Published var currentFilter: FilterType = .none

    // Динамический поиск
    var filteredClients: [Client] {
        var result = clients
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        // Фильтрация по фильтру (пример — по дате следующей тренировки)
        switch currentFilter {
        case .nextSessionDate:
            result = result.sorted { (lhs, rhs) in
                let lDate = nextSession(for: lhs)?.date ?? Date.distantFuture
                let rDate = nextSession(for: rhs)?.date ?? Date.distantFuture
                return lDate < rDate
            }
        case .nextSessionType:
            // Можно сортировать по title или другому признаку
            result = result.sorted { (lhs, rhs) in
                let lType = nextSession(for: lhs)?.workoutTitle ?? ""
                let rType = nextSession(for: rhs)?.workoutTitle ?? ""
                return lType < rType
            }
        default: break
        }
        return result
    }

    // Моки clientStats (оставь если нужны карточки-статистики)
    var clientStats: [StatSummary] {
        [
            StatSummary(id: "clients", title: "Всего клиентов", value: "\(clients.count)", icon: "person.2", hasDot: false),
            StatSummary(id: "active", title: "Идёт сейчас", value: "\(currentSessionsCount)", icon: "flame", hasDot: currentSessionsCount > 0),
            StatSummary(id: "feedback", title: "Отзывов", value: "\(feedbackCount)", icon: "bubble.left", hasDot: false)
        ]
    }
    
    func applyFilter(_ filter: FilterType) {
        currentFilter = filter
    }

    // Логика поиска last/next session
    func lastSession(for client: Client) -> Session? {
        sessions
            .filter { $0.clientId == client.id && $0.status == .completed && $0.date < Date() }
            .sorted { $0.date > $1.date }
            .first
    }

    func nextSession(for client: Client) -> Session? {
        sessions
            .filter { $0.clientId == client.id && $0.status == .planned && $0.date > Date() }
            .sorted { $0.date < $1.date }
            .first
    }
    
    // Вычисляет число текущих сессий (статус inProgress)
    var currentSessionsCount: Int {
        sessions.filter { $0.status == .inProgress }.count
    }
    // Отзывы — если есть, или пока всегда "0"
    var feedbackCount: Int { 2 }
    // ...
}
