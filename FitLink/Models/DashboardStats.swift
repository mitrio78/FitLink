//
//  DashboardStats.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

// Models/DashboardModels.swift

import Foundation

struct DashboardStats: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let systemImage: String
}
