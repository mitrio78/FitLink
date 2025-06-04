//
//  Date+Ext.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//

import Foundation

extension Date {
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) { return NSLocalizedString("DateExtensions.Today", comment: "сегодня") }
        if calendar.isDateInYesterday(self) { return NSLocalizedString("DateExtensions.Yesterday", comment: "вчера") }
        let days = calendar.dateComponents([.day], from: self, to: Date()).day ?? 0
        return "\(days) " + NSLocalizedString("DateExtensions.DaysAgoSuffix", comment: "дн. назад")
    }
    
    func formattedShort() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter.string(from: self)
    }
    
    func formattedHuman() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM, HH:mm"
        return formatter.string(from: self)
    }

}
