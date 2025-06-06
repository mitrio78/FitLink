//
//  WorkoutSessionView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//
import SwiftUI

struct WorkoutSessionView: View {
    let session: WorkoutSession
    let client: Client?
    
    // 1. Вынеси фильтрацию в отдельную переменную (читабельность)
    var singleExercises: [ExerciseInstance] {
        let groupedIds = Set((session.setGroups ?? []).flatMap { $0.exerciseInstanceIds })
        return session.exerciseInstances.filter { !groupedIds.contains($0.id) }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                // Заголовок
                Text(
                    String(
                        format: NSLocalizedString("WorkoutSession.Header", comment: "Тренировка для %@"),
                        client?.name ?? NSLocalizedString("WorkoutSession.ClientPlaceholder", comment: "Клиента")
                    )
                )
                .font(Theme.font.titleMedium).bold()
                if let date = session.date {
                    Text("\(date.formatted(date: .long, time: .shortened))")
                        .foregroundColor(Theme.color.textSecondary)
                }
                if let notes = session.notes, !notes.isEmpty {
                    Text(notes)
                        .font(Theme.font.body)
                        .foregroundColor(Theme.color.accent)
                        .padding(.vertical, Theme.spacing.small / 2)
                }
                
                // --- Универсальный список упражнений и групп ---
                ForEach(session.exerciseInstances) { exerciseInstance in
                    // Проверяем, входит ли упражнение в какую-либо группу
                    if let group = (session.setGroups?.first { $0.exerciseInstanceIds.contains(exerciseInstance.id) }) {
                        // Если это первое упражнение группы — рендерим карточку группы
                        if group.exerciseInstanceIds.first == exerciseInstance.id {
                            let groupExercises = session.exerciseInstances.filter { group.exerciseInstanceIds.contains($0.id) }
                            ExerciseBlockCard(group: group, exerciseInstances: groupExercises)
                        }
                        // Остальные упражнения группы не рендерим отдельно
                    } else {
                        // Одиночное упражнение
                        ExerciseBlockCard(group: nil, exerciseInstances: [exerciseInstance])
                    }
                }
            }
            .padding(Theme.spacing.medium)
        }
        .navigationTitle(NSLocalizedString("WorkoutSession.Title", comment: "Тренировка"))
        .presentationDetents([.medium, .large])
    }
}


#Preview {
    WorkoutSessionView(session: MockData.complexMockSessions[15], client: clientsMock[0])
}
