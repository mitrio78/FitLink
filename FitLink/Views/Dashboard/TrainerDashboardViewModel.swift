//
//  DashboardViewModel.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import Foundation
import Combine

@MainActor
final class TrainerDashboardViewModel: ObservableObject {
    @Published var clientStats = [
        StatCard(title: "Клиенты", value: "12"),
        StatCard(title: "Идёт тренировка", value: "3"),
        StatCard(title: "Обратная связь", value: "5", hasDot: true)
    ]
    @Published var searchText: String = ""
    
    @Published var clients: [Client] = [
        Client(name: "Гришечко Дмитрий", avatarURL: nil,
               lastSessionDescription: "Full Body HIIT · 2 дня назад", nextSession: "17:00", nextSessionAccent: "Следующая: 5:00pm"),
        Client(name: "Иван Васильев", avatarURL: nil,
               lastSessionDescription: "Upper Body Strength · 3 дня назад", nextSession: "Чт", nextSessionAccent: "Следующая: Thu"),
        Client(name: "Анна Белова", avatarURL: nil,
               lastSessionDescription: "Mobility Session · 3 дня назад", nextSession: "Пт", nextSessionAccent: "Следующая: Fri"),
        Client(name: "Михаил Столбов", avatarURL: nil,
               lastSessionDescription: "Cardio Blast · 4 дня назад", nextSession: "Сб", nextSessionAccent: "Следующая: Sat")
    ]
    
    var filteredClients: [Client] {
        if searchText.isEmpty {
            return clients
        }
        let lowercased = searchText.lowercased()
        return clients.filter {
            $0.name.lowercased().contains(lowercased)
            || $0.lastSessionDescription.lowercased().contains(lowercased)
        }
    }
    
    func applyFilter(_ filter: FilterType) {
        // Реализация фильтрации — сортировка/фильтрация clients в зависимости от выбранного filter
        // Например, по дате или типу тренировки
    }
}
