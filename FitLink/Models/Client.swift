//
//  Client.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//
import Foundation

struct Client: Identifiable {
    let id = UUID()
    let name: String
    let avatarURL: URL?
    let lastSessionDescription: String
    let nextSession: String // Пример: "5:00pm" или "Thu"
    let nextSessionAccent: String // Например: "Next: 5:00pm"
}
