//
//  WorkoutProgram.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 30.05.2025.
//
import Foundation

struct WorkoutProgram: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var description: String?
    var sessions: [WorkoutSession]
    var createdBy: UUID     // id пользователя, кто составил программу
    var startDate: Date?
    var endDate: Date?
}
