//
//  WorkoutSessionView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//
import SwiftUI

struct WorkoutSessionView: View {
    @StateObject private var viewModel: WorkoutSessionViewModel

    init(session: WorkoutSession, client: Client?) {
        _viewModel = StateObject(wrappedValue: WorkoutSessionViewModel(session: session, client: client))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Заголовок
                Text(
                    String(
                        format: NSLocalizedString("WorkoutSession.Header", comment: "Тренировка для %@"),
                        viewModel.client?.name ?? NSLocalizedString("WorkoutSession.ClientPlaceholder", comment: "Клиента")
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

                workoutSectionView(title: WorkoutSection.warmUp.displayTitle, exercises: viewModel.warmUpExercises)
                workoutSectionView(title: WorkoutSection.main.displayTitle, exercises: viewModel.mainExercises)
                workoutSectionView(title: WorkoutSection.coolDown.displayTitle, exercises: viewModel.coolDownExercises)
            }
            .padding(Theme.spacing.medium)
            .padding(.bottom, Theme.spacing.medium)
        }
        .navigationTitle(NSLocalizedString("WorkoutSession.Title", comment: "Тренировка"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.addExerciseTapped) {
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
        .sheet(isPresented: $viewModel.showExerciseEdit) {
            WorkoutExerciseEditView(sessionStore: WorkoutStore(), sessionId: viewModel.session.id)
        }
    }

    @ViewBuilder
    private func workoutSectionView(title: String, exercises: [ExerciseInstance]) -> some View {
        if !exercises.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                WorkoutSectionHeaderView(title: title)

                VStack(spacing: Theme.spacing.small) {
                    ForEach(exercises) { ex in
                        if let group = viewModel.group(for: ex), viewModel.isFirstExerciseInGroup(ex) {
                            let groupExercises = viewModel.groupExercises(for: group)
                            if group.type == .superset {
                                SupersetCell(group: group, exercises: groupExercises)
                            } else {
                                ExerciseBlockCard(group: group, exerciseInstances: groupExercises)
                            }
                        } else if !viewModel.isExerciseInAnyGroup(ex) {
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
