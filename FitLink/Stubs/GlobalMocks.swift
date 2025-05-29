import Foundation
import SwiftUI

import Foundation
import SwiftUI

// Моки клиентов
let mockClients: [Client] = [
    Client(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
        name: "Иван Васильев",
        avatarURL: nil
    ),
    Client(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
        name: "Анна Петрова",
        avatarURL: nil
    ),
    Client(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
        name: "Максим Орлов",
        avatarURL: nil
    ),
    Client(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
        name: "Дмитрий Беляев",
        avatarURL: nil
    ),
    Client(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
        name: "Светлана Новикова",
        avatarURL: nil
    ),
    Client(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
        name: "Артём Гаврилов",
        avatarURL: nil
    )
]

// Фиксированная базовая дата для стабильности моков
let baseDate = Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 29, hour: 12, minute: 0))!

// Моки сессий
let mockSessions: [Session] = [
    // Иван Васильев: прошлое, сегодня, будущее
    Session(
        clientId: mockClients[0].id,
        clientName: mockClients[0].name,
        clientAvatar: nil,
        workoutTitle: "Жим лёжа",
        date: Calendar.current.date(byAdding: .day, value: -2, to: baseDate)!,
        time: "10:00",
        status: .completed
    ),
    Session(
        clientId: mockClients[0].id,
        clientName: mockClients[0].name,
        clientAvatar: nil,
        workoutTitle: "Кардио",
        date: baseDate,
        time: "11:00",
        status: .completed
    ),
    Session(
        clientId: mockClients[0].id,
        clientName: mockClients[0].name,
        clientAvatar: nil,
        workoutTitle: "Плавание",
        date: Calendar.current.date(byAdding: .day, value: 1, to: baseDate)!,
        time: "09:30",
        status: .planned
    ),
    // Анна Петрова
    Session(
        clientId: mockClients[1].id,
        clientName: mockClients[1].name,
        clientAvatar: nil,
        workoutTitle: "Приседания",
        date: Calendar.current.date(byAdding: .day, value: -1, to: baseDate)!,
        time: "14:00",
        status: .completed
    ),
    Session(
        clientId: mockClients[1].id,
        clientName: mockClients[1].name,
        clientAvatar: nil,
        workoutTitle: "Кардио",
        date: baseDate,
        time: "18:00",
        status: .planned
    ),
    Session(
        clientId: mockClients[1].id,
        clientName: mockClients[1].name,
        clientAvatar: nil,
        workoutTitle: "Йога",
        date: Calendar.current.date(byAdding: .day, value: 2, to: baseDate)!,
        time: "08:00",
        status: .planned
    ),
    // Максим Орлов
    Session(
        clientId: mockClients[2].id,
        clientName: mockClients[2].name,
        clientAvatar: nil,
        workoutTitle: "Беговая дорожка",
        date: Calendar.current.date(byAdding: .day, value: -3, to: baseDate)!,
        time: "17:30",
        status: .completed
    ),
    Session(
        clientId: mockClients[2].id,
        clientName: mockClients[2].name,
        clientAvatar: nil,
        workoutTitle: "Силовая тренировка",
        date: baseDate,
        time: "20:00",
        status: .planned
    ),
    Session(
        clientId: mockClients[2].id,
        clientName: mockClients[2].name,
        clientAvatar: nil,
        workoutTitle: "Растяжка",
        date: Calendar.current.date(byAdding: .day, value: 2, to: baseDate)!,
        time: "09:00",
        status: .planned
    ),
    // Дмитрий Беляев
    Session(
        clientId: mockClients[3].id,
        clientName: mockClients[3].name,
        clientAvatar: nil,
        workoutTitle: "Велотренажёр",
        date: Calendar.current.date(byAdding: .day, value: -1, to: baseDate)!,
        time: "15:00",
        status: .completed
    ),
    Session(
        clientId: mockClients[3].id,
        clientName: mockClients[3].name,
        clientAvatar: nil,
        workoutTitle: "Кардио",
        date: Calendar.current.date(byAdding: .hour, value: 3, to: baseDate)!,
        time: "15:00",
        status: .planned
    ),
    // Светлана Новикова
    Session(
        clientId: mockClients[4].id,
        clientName: mockClients[4].name,
        clientAvatar: nil,
        workoutTitle: "Йога",
        date: Calendar.current.date(byAdding: .day, value: -2, to: baseDate)!,
        time: "10:00",
        status: .completed
    ),
    Session(
        clientId: mockClients[4].id,
        clientName: mockClients[4].name,
        clientAvatar: nil,
        workoutTitle: "Бокс",
        date: baseDate,
        time: "12:30",
        status: .planned
    ),
    Session(
        clientId: mockClients[4].id,
        clientName: mockClients[4].name,
        clientAvatar: nil,
        workoutTitle: "Пилатес",
        date: Calendar.current.date(byAdding: .day, value: 3, to: baseDate)!,
        time: "16:30",
        status: .planned
    ),
    // Артём Гаврилов
    Session(
        clientId: mockClients[5].id,
        clientName: mockClients[5].name,
        clientAvatar: nil,
        workoutTitle: "Силовая тренировка",
        date: Calendar.current.date(byAdding: .day, value: -4, to: baseDate)!,
        time: "13:00",
        status: .completed
    ),
    Session(
        clientId: mockClients[5].id,
        clientName: mockClients[5].name,
        clientAvatar: nil,
        workoutTitle: "Плавание",
        date: Calendar.current.date(byAdding: .day, value: 1, to: baseDate)!,
        time: "18:00",
        status: .planned
    ),
    Session(
        clientId: mockClients[5].id,
        clientName: mockClients[5].name,
        clientAvatar: nil,
        workoutTitle: "Кардио",
        date: Calendar.current.date(byAdding: .day, value: 2, to: baseDate)!,
        time: "19:00",
        status: .planned
    )
]
