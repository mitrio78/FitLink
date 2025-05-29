//
//  AppCoclors.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//

import SwiftUI

extension Color {
    static let accentMain = Color(hex: "#4094ED")    // Акцентный синий
    static let accentSecondary = Color(hex: "#3DC6B6") // Альтернативный акцент
    static let bgMain = Color(hex: "#F9F9FB")        // Основной фон
    static let card = Color.white                    // Карточки
    static let textPrimary = Color(hex: "#18191A")   // Основной текст
    static let textSecondary = Color(hex: "#7D7D89") // Вторичный текст
    static let borderLight = Color(hex: "#E5E7EB")   // Лёгкая рамка
    static let statWarning = Color(hex: "#FFA940")
    static let statSuccess = Color(hex: "#50C878")
    static let statDanger = Color(hex: "#E74C3C")
    static let accentDark = Color(hex: "#23272F")
    static let badgeBackground = Color(hex: "#FFF4E0") // Очень светлый оранжевый
    static let badgeText = Color(hex: "#FFA940")       // Яркий оранжевый
    
    // Позволяет инициализировать через hex:
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
