//
//  WorkoutSessionView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//
import SwiftUI

struct WorkoutSessionView: View {
    @StateObject private var viewModel: WorkoutSessionViewModel
    let client: Client?

    init(session: WorkoutSession, client: Client?) {
        _viewModel = StateObject(wrappedValue: WorkoutSessionViewModel(session: session))
        self.client = client
    }

    private var warmUpExercises: [ExerciseInstance] {
        viewModel.warmUpExercises
    }

    private var mainExercises: [ExerciseInstance] {
        viewModel.mainExercises
    }

    private var coolDownExercises: [ExerciseInstance] {
        viewModel.coolDownExercises
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
                if let date = viewModel.session.date {
                    Text("\(date.formatted(date: .long, time: .shortened))")
                        .foregroundColor(Theme.color.textSecondary)
                }
                if let notes = viewModel.session.notes, !notes.isEmpty {
                    Text(notes)
                        .font(Theme.font.body)
                        .foregroundColor(Theme.color.accent)
                        .padding(.vertical, Theme.spacing.small)
                }

                workoutSectionView(title: WorkoutSection.warmUp.displayTitle, exercises: warmUpExercises)
                workoutSectionView(title: WorkoutSection.main.displayTitle, exercises: mainExercises)
                workoutSectionView(title: WorkoutSection.coolDown.displayTitle, exercises: coolDownExercises)

                PrimaryButton(title: WorkoutSessionAction.addExercise.buttonTitle) {}
                    .padding(.top, Theme.spacing.extraLarge)
            }
            .padding(Theme.spacing.medium)
            .padding(.bottom, Theme.spacing.medium)
        } //: VStack
        .navigationTitle(NSLocalizedString("WorkoutSession.Title", comment: "Тренировка"))
        .presentationDetents([.medium, .large])
    }

    @ViewBuilder
    private func workoutSectionView(title: String, exercises: [ExerciseInstance]) -> some View {
        if !exercises.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                WorkoutSectionHeaderView(title: title)

                VStack(spacing: Theme.spacing.small) {
                    ForEach(exercises) { ex in
                        if let group = viewModel.session.setGroups?.first(where: { $0.exerciseInstanceIds.contains(ex.id) }),
                           group.exerciseInstanceIds.first == ex.id {
                            let groupExercises = viewModel.session.exerciseInstances.filter { group.exerciseInstanceIds.contains($0.id) }
                            WorkoutExerciseRowView(group: group, exercises: groupExercises)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.deleteExercise(withId: ex.id)
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }
                                }
                        } else if !(viewModel.session.setGroups ?? []).contains(where: { $0.exerciseInstanceIds.contains(ex.id) }) {
                            WorkoutExerciseRowView(exercise: ex)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.deleteExercise(withId: ex.id)
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }
                                }
                        }
                    }
                } //: VStack
            } //: VStack
        }
    }
}


#Preview {
    WorkoutSessionView(session: MockData.complexMockSessions[15], client: clientsMock[0])
}
