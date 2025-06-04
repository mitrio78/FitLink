//
//  Sessions+Seeds.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 30.05.2025.
//

import Foundation

let mockSessions: [WorkoutSession] = [
    WorkoutSession(
        id: UUID(),
        clientId: clientsMock[0].id,
        title: "Грудь и трицепс",
        date: ISO8601DateFormatter().date(from: "2025-05-20T10:00:00+03:00"),
        exerciseInstances: [
            makeInstance(exercise: exercisesCatalog[0], approachesCount: 3), // Жим лёжа
            makeInstance(exercise: exercisesCatalog[4], approachesCount: 3), // Отжимания на брусьях
            makeInstance(exercise: exercisesCatalog[7], approachesCount: 3)  // Разгибания рук на блоке
        ],
        setGroups: nil,
        notes: "Фокус на жим лёжа",
        status: .completed
    ),
    WorkoutSession(
        id: UUID(),
        clientId: clientsMock[0].id,
        title: "Кардио + пресс",
        date: ISO8601DateFormatter().date(from: "2025-05-22T08:30:00+03:00"),
        exerciseInstances: [
            makeInstance(exercise: exercisesCatalog[18], approachesCount: 1), // Кардио: бег на дорожке
            makeInstance(exercise: exercisesCatalog[9], approachesCount: 3)   // Скручивания на пресс
        ],
        setGroups: nil,
        notes: nil,
        status: .completed
    ),
    WorkoutSession(
        id: UUID(),
        clientId: clientsMock[0].id,
        title: "Спина и бицепс",
        date: ISO8601DateFormatter().date(from: "2025-05-28T19:00:00+03:00"),
        exerciseInstances: [
            makeInstance(exercise: exercisesCatalog[1], approachesCount: 3), // Становая тяга
            makeInstance(exercise: exercisesCatalog[3], approachesCount: 2), // Подтягивания
            makeInstance(exercise: exercisesCatalog[13], approachesCount: 3) // Тяга штанги в наклоне
        ],
        setGroups: nil,
        notes: "Добавить тягу верхнего блока",
        status: .planned
    ),
    WorkoutSession(
        id: UUID(),
        clientId: clientsMock[1].id,
        title: "Кардио",
        date: ISO8601DateFormatter().date(from: "2025-05-21T09:15:00+03:00"),
        exerciseInstances: [
            makeInstance(exercise: exercisesCatalog[18], approachesCount: 1), // Кардио: бег на дорожке
            makeInstance(exercise: exercisesCatalog[19], approachesCount: 2)  // Скакалка
        ],
        setGroups: nil,
        notes: "Беговая дорожка 30 минут",
        status: .completed
    ),
    WorkoutSession(
        id: UUID(),
        clientId: clientsMock[1].id,
        title: "Ноги и ягодицы",
        date: ISO8601DateFormatter().date(from: "2025-05-25T18:00:00+03:00"),
        exerciseInstances: [
            makeInstance(exercise: exercisesCatalog[2], approachesCount: 3), // Приседания
            makeInstance(exercise: exercisesCatalog[10], approachesCount: 2), // Выпады
            makeInstance(exercise: exercisesCatalog[16], approachesCount: 2) // Подъёмы на икры
        ],
        setGroups: nil,
        notes: nil,
        status: .planned
    ),
    WorkoutSession(
        id: UUID(),
        clientId: clientsMock[1].id,
        title: "Йога и растяжка",
        date: ISO8601DateFormatter().date(from: "2025-06-03T17:00:00+03:00"),
        exerciseInstances: [
            makeInstance(exercise: exercisesCatalog[14], approachesCount: 1), // Растяжка стоя
        ],
        setGroups: nil,
        notes: "Релакс",
        status: .planned
    ),
    WorkoutSession(
        id: UUID(),
        clientId: clientsMock[2].id,
        title: "Грудные + плечи",
        date: ISO8601DateFormatter().date(from: "2025-05-23T10:00:00+03:00"),
        exerciseInstances: [
            makeInstance(exercise: exercisesCatalog[0], approachesCount: 3), // Жим лёжа
            makeInstance(exercise: exercisesCatalog[5], approachesCount: 2), // Жим гантелей стоя
            makeInstance(exercise: exercisesCatalog[12], approachesCount: 2) // Махи гантелями в стороны
        ],
        setGroups: nil,
        notes: nil,
        status: .completed
    ),
    WorkoutSession(
        id: UUID(),
        clientId: clientsMock[2].id,
        title: "Силовая тренировка",
        date: ISO8601DateFormatter().date(from: "2025-05-29T18:30:00+03:00"),
        exerciseInstances: [
            makeInstance(exercise: exercisesCatalog[1], approachesCount: 3), // Становая тяга
            makeInstance(exercise: exercisesCatalog[2], approachesCount: 2) // Приседания со штангой
        ],
        setGroups: nil,
        notes: "Фокус: становая тяга",
        status: .planned
    ),
    WorkoutSession(
        id: UUID(),
        clientId: clientsMock[2].id,
        title: "Фулбади",
        date: ISO8601DateFormatter().date(from: "2025-06-02T11:00:00+03:00"),
        exerciseInstances: [
            makeInstance(exercise: exercisesCatalog[6], approachesCount: 2), // Сгибания рук с гантелями
            makeInstance(exercise: exercisesCatalog[8], approachesCount: 2), // Планка
            makeInstance(exercise: exercisesCatalog[15], approachesCount: 2) // Тяга верхнего блока
        ],
        setGroups: nil,
        notes: nil,
        status: .planned
    ),
    WorkoutSession(
        id: UUID(),
        clientId: clientsMock[3].id,
        title: "Йога",
        date: ISO8601DateFormatter().date(from: "2025-05-24T09:00:00+03:00"),
        exerciseInstances: [
            makeInstance(exercise: exercisesCatalog[14], approachesCount: 1), // Растяжка стоя
            makeInstance(exercise: exercisesCatalog[8], approachesCount: 3)   // Планка
        ],
        setGroups: nil,
        notes: "Дыхательные практики",
        status: .completed
    ),
    WorkoutSession(
        id: UUID(),
        clientId: clientsMock[3].id,
        title: "Кардио + пресс",
        date: ISO8601DateFormatter().date(from: "2025-05-31T08:00:00+03:00"),
        exerciseInstances: [
            makeInstance(exercise: exercisesCatalog[18], approachesCount: 1), // Кардио: бег на дорожке
            makeInstance(exercise: exercisesCatalog[9], approachesCount: 2)   // Скручивания на пресс
        ],
        setGroups: nil,
        notes: nil,
        status: .planned
    ),
    WorkoutSession(
        id: UUID(),
        clientId: clientsMock[4].id,
        title: "Трицепс и грудь",
        date: ISO8601DateFormatter().date(from: "2025-05-26T19:30:00+03:00"),
        exerciseInstances: [
            makeInstance(exercise: exercisesCatalog[4], approachesCount: 3), // Отжимания на брусьях
            makeInstance(exercise: exercisesCatalog[7], approachesCount: 2) // Разгибания рук на блоке
        ],
        setGroups: nil,
        notes: nil,
        status: .completed
    ),
    WorkoutSession(
        id: UUID(),
        clientId: clientsMock[4].id,
        title: "Бег",
        date: ISO8601DateFormatter().date(from: "2025-05-27T08:00:00+03:00"),
        exerciseInstances: [
            makeInstance(exercise: exercisesCatalog[18], approachesCount: 2) // Кардио: бег на дорожке
        ],
        setGroups: nil,
        notes: nil,
        status: .planned
    ),
    WorkoutSession(
        id: UUID(),
        clientId: clientsMock[4].id,
        title: "Силовой тренинг",
        date: ISO8601DateFormatter().date(from: "2025-06-04T18:00:00+03:00"),
        exerciseInstances: [
            makeInstance(exercise: exercisesCatalog[1], approachesCount: 3), // Становая тяга
            makeInstance(exercise: exercisesCatalog[2], approachesCount: 2) // Приседания со штангой
        ],
        setGroups: nil,
        notes: "Присед, становая",
        status: .planned
    ),
    WorkoutSession(
        id: UUID(),
        clientId: clientsMock[4].id,
        title: "Растяжка",
        date: ISO8601DateFormatter().date(from: "2025-06-01T11:00:00+03:00"),
        exerciseInstances: [
            makeInstance(exercise: exercisesCatalog[14], approachesCount: 1) // Растяжка стоя
        ],
        setGroups: nil,
        notes: nil,
        status: .planned
    )
]
