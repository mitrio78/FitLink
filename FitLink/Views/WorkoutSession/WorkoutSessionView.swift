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

    private var warmUpExercises: [ExerciseInstance] {
        session.exerciseInstances.filter { $0.section == .warmUp }
    }

    private var mainExercises: [ExerciseInstance] {
        session.exerciseInstances.filter { $0.section == .main }
    }

    private var coolDownExercises: [ExerciseInstance] {
        session.exerciseInstances.filter { $0.section == .coolDown }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.spacing.large) {
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

                workoutSectionView(title: WorkoutSection.warmUp.title, exercises: warmUpExercises)
                workoutSectionView(title: WorkoutSection.main.title, exercises: mainExercises)
                workoutSectionView(title: WorkoutSection.coolDown.title, exercises: coolDownExercises)

                VStack(spacing: Theme.spacing.medium) {
                    Button(NSLocalizedString("WorkoutSession.AddGroupedExercise", comment: "")) {}
                    Button(NSLocalizedString("WorkoutSession.AddBlock", comment: "")) {}
                    Button(NSLocalizedString("WorkoutSession.ClonePrevious", comment: "")) {}
                    Button(NSLocalizedString("WorkoutSession.Save", comment: "")) {}
                }
            }
            .padding(Theme.spacing.medium)
        }
        .navigationTitle(NSLocalizedString("WorkoutSession.Title", comment: "Тренировка"))
        .presentationDetents([.medium, .large])
    }

    @ViewBuilder
    private func workoutSectionView(title: String, exercises: [ExerciseInstance]) -> some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small) {
            Text(title)
                .font(Theme.font.subheading).bold()

            ForEach(exercises) { ex in
                if let group = session.setGroups?.first(where: { $0.exerciseInstanceIds.contains(ex.id) }),
                   group.exerciseInstanceIds.first == ex.id {
                    let groupExercises = session.exerciseInstances.filter { group.exerciseInstanceIds.contains($0.id) }
                    ExerciseBlockCard(group: group, exerciseInstances: groupExercises)
                } else if !(session.setGroups ?? []).contains(where: { $0.exerciseInstanceIds.contains(ex.id) }) {
                    ExerciseBlockCard(group: nil, exerciseInstances: [ex])
                }
            }

            Button(NSLocalizedString("WorkoutSession.AddExercise", comment: "")) {}
                .font(Theme.font.body)
                .foregroundColor(Theme.color.accent)
        }
    }
}


#Preview {
    WorkoutSessionView(session: MockData.complexMockSessions[15], client: clientsMock[0])
}
