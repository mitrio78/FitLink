//
//  Clients+Seeds.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 30.05.2025.
//

import Foundation

let clientsMock: [Client] = [
    Client(id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!, name: "Иван Петров", avatarURL: nil),
    Client(id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!, name: "Мария Смирнова", avatarURL: nil),
    Client(id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!, name: "Денис Волков", avatarURL: nil),
    Client(id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!, name: "София Орлова", avatarURL: nil),
    Client(id: UUID(uuidString: "55555555-5555-5555-5555-555555555555")!, name: "Артём Кузнецов", avatarURL: nil)
]
let clientsDict: [UUID: Client] = Dictionary(uniqueKeysWithValues: clientsMock.map { ($0.id, $0) })
