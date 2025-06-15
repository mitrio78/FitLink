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

    @State private var showExerciseEdit = false

    private func addExerciseTapped() {
        showExerciseEdit = true
    }

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
            VStack(alignment: .leading, spacing: 0) {
                // Заголовок
                Text(
                    String(
                        format: NSLocalizedString("WorkoutSession.Header", comment: "Тренировка для %@"),
                        client?.name ?? NSLocalizedString("WorkoutSession.ClientPlaceholder", comment: "Клиента")
                    )
                )
                .font(Theme.font.titleMedium).bold()
                .padding(.vertical)
                if let date = session.date {
                    Text("\(date.formatted(date: .long, time: .shortened))")
                        .foregroundColor(Theme.color.textSecondary)
                }
                if let notes = session.notes, !notes.isEmpty {
                    Text(notes)
                        .font(Theme.font.body)
                        .foregroundColor(Theme.color.accent)
                        .padding(.vertical, Theme.spacing.small)
                }

                workoutSectionView(title: WorkoutSection.warmUp.displayTitle, exercises: warmUpExercises)
                workoutSectionView(title: WorkoutSection.main.displayTitle, exercises: mainExercises)
                workoutSectionView(title: WorkoutSection.coolDown.displayTitle, exercises: coolDownExercises)
            }
            .padding(Theme.spacing.medium)
            .padding(.bottom, Theme.spacing.medium)
        }
        .navigationTitle(NSLocalizedString("WorkoutSession.Title", comment: "Тренировка"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: addExerciseTapped) {
                    Image(systemName: "plus")
                        .padding(6)
                        .background(Color.accentColor.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .controlSize(.large)
                .foregroundColor(Color.accentColor)
                .accessibilityLabel(NSLocalizedString("WorkoutDetail.AddExercise", comment: ""))
                .accessibilityIdentifier("WorkoutDetail.AddExerciseButton")
            }
        }
        .presentationDetents([.medium, .large])
        .sheet(isPresented: $showExerciseEdit) {
            WorkoutExerciseEditView(sessionStore: WorkoutStore(), sessionId: session.id)
        }
    }

    @ViewBuilder
    private func workoutSectionView(title: String, exercises: [ExerciseInstance]) -> some View {
        if !exercises.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                WorkoutSectionHeaderView(title: title)

                VStack(spacing: Theme.spacing.small) {
                    ForEach(exercises) { ex in
                        if let group = session.setGroups?.first(where: { $0.exerciseInstanceIds.contains(ex.id) }),
                           group.exerciseInstanceIds.first == ex.id {
                            let groupExercises = session.exerciseInstances.filter { group.exerciseInstanceIds.contains($0.id) }
                            ExerciseBlockCard(group: group, exerciseInstances: groupExercises)
                        } else if !(session.setGroups ?? []).contains(where: { $0.exerciseInstanceIds.contains(ex.id) }) {
                            ExerciseBlockCard(group: nil, exerciseInstances: [ex])
                        }
                    }
                }
            }
        }
    }
}


#Preview("Light") {
    NavigationStack {
        WorkoutSessionView(session: MockData.complexMockSessions[15], client: clientsMock[0])
    }
}

#Preview("Dark") {
    NavigationStack {
        WorkoutSessionView(session: MockData.complexMockSessions[15], client: clientsMock[0])
    }
    .preferredColorScheme(.dark)
}
