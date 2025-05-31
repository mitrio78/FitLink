//
//  DateFormatterService.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 30.05.2025.
//

import Foundation

final class DateFormatterService {
    static let shared = DateFormatterService()

    // Приватные форматтеры, лениво инициализируются
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    private lazy var relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.unitsStyle = .full
        return formatter
    }()
    
    /// "Сегодня", "Вчера", "30 мая 2025"
    func formattedDate(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Сегодня"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Вчера"
        } else {
            return dateFormatter.string(from: date)
        }
    }
    
    /// "14:00"
    func formattedTime(_ date: Date) -> String {
        timeFormatter.string(from: date)
    }
    
    /// "3 дня назад", "через 2 недели"
    func formattedRelative(_ date: Date) -> String {
        relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
}
