//
//  StatCard.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//
import Foundation

struct StatCard: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    var hasDot: Bool = false
}
