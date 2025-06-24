//
//  WorkoutSessionView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//
import SwiftUI

struct WorkoutSessionView: View {
    @EnvironmentObject private var dataStore: AppDataStore
    @StateObject private var viewModel: WorkoutSessionViewModel

    init(session: WorkoutSession, client: Client?) {
        _viewModel = StateObject(wrappedValue: WorkoutSessionViewModel(session: session, client: client, dataStore: AppDataStore.shared))
    }

    init(session: WorkoutSession, client: Client?, store: WorkoutStore) {
        self.init(session: session, client: client)
    }
    
    var body: some View {
        List {
            headerSection

            workoutSection(.warmUp, exercises: viewModel.warmUpExercises)
            workoutSection(.main, exercises: viewModel.mainExercises)
            workoutSection(.coolDown, exercises: viewModel.coolDownExercises)
        }
        .listStyle(.plain)
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
            WorkoutExerciseEditView(initialExercises: viewModel.editingContext?.exercises ?? []) { result in
                viewModel.completeEdit(result)
            }
        }
        .sheet(item: $viewModel.activeMetricEdit) { context in
            CustomNumberPadView(
                value: Binding(
                    get: { viewModel.activeMetricEdit?.currentValue ?? 0 },
                    set: { viewModel.activeMetricEdit?.currentValue = $0 }
                ),
                unit: context.unit,
                onDone: {
                    viewModel.saveEditedMetric()
                },
                onCancel: { viewModel.activeMetricEdit = nil }
            )
            .presentationDetents([.fraction(0.65)])
        }
    }

    private var headerSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 0) {
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
            } //: VStack
        }
    }

    @ViewBuilder
    private func workoutSection(_ section: WorkoutSection, exercises: [ExerciseInstance]) -> some View {
        if !exercises.isEmpty {
            Section {
                ForEach(exercises, id: \.id) { ex in
                    if let group = viewModel.group(for: ex), viewModel.isFirstExerciseInGroup(ex) {
                        let groupExercises = viewModel.groupExercises(for: group)
                        WorkoutExerciseRowView(
                            exercise: ex,
                            group: group,
                            groupExercises: groupExercises,
                            onEdit: { viewModel.editItemTapped(withId: group.id) },
                            onDelete: { viewModel.deleteItem(withId: group.id) },
                            onMetricEdit: { ex, setId, metric in
                                viewModel.edit(metric: metric, forSet: setId, ofExercise: ex.id)
                            },
                            initiallyExpanded: viewModel.expandedGroupId == group.id
                        )
                        .onAppear {
                            if viewModel.expandedGroupId == group.id {
                                viewModel.expandedGroupId = nil
                            }
                        }
                        .listRowSeparator(.hidden)
                    } else if !viewModel.isExerciseInAnyGroup(ex) {
                        WorkoutExerciseRowView(
                            exercise: ex,
                            group: nil,
                            onEdit: { viewModel.editItemTapped(withId: ex.id) },
                            onDelete: { viewModel.deleteItem(withId: ex.id) },
                            onMetricEdit: { ex, setId, metric in
                                viewModel.edit(metric: metric, forSet: setId, ofExercise: ex.id)
                            }
                        )
                        .listRowSeparator(.hidden)
                    }
                }
            } header: {
                WorkoutSectionHeaderView(title: section.displayTitle)
            }
        }
    }
}


#Preview("Light") {
    NavigationStack {
        WorkoutSessionView(session: MockData.complexMockSessions[15], client: clientsMock[0], store: WorkoutStore())
    }
}

#Preview("Dark") {
    NavigationStack {
        WorkoutSessionView(session: MockData.complexMockSessions[15], client: clientsMock[0], store: WorkoutStore())
    }
    .preferredColorScheme(.dark)
}
