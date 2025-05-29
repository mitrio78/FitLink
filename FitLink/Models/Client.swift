//
//  Client.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//
import Foundation

struct Client: Identifiable, Hashable {
    let id: UUID
    let name: String
    let avatarURL: URL?
    
    var initials: String {
        let nameComponents = name.components(separatedBy: " ")
        let first = nameComponents.first?.first.map { String($0) } ?? ""
        let last = nameComponents.dropFirst().first?.first.map { String($0) } ?? ""
        return first + last
    }
}

struct StatSummary: Identifiable {
    let id: String
    let title: String
    let value: String
    let icon: String?
    let hasDot: Bool
}
