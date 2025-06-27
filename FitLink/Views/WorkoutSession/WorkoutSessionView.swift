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
                .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))

            workoutSection(.warmUp, exercises: viewModel.warmUpExercises)
            workoutSection(.main, exercises: viewModel.mainExercises)
            workoutSection(.coolDown, exercises: viewModel.coolDownExercises)
        }
        .listStyle(.plain)
        .padding(.horizontal, Theme.spacing.horizontal)
        .navigationTitle(NSLocalizedString("WorkoutSession.Title", comment: "Тренировка"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.addExerciseTapped) {
                    Image(systemName: "plus")
                        .padding(8)
                        .background(Theme.color.backgroundSecondary .opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .controlSize(.large)
                .foregroundColor(Theme.color.accent)
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
        .sheet(item: $viewModel.activeSetEdit) { context in
            CustomNumberPadView(
                metrics: context.metrics,
                values: Binding<[ExerciseMetric.ID: ExerciseMetricValue]>(
                    get: { viewModel.activeSetEdit?.values ?? [:] },
                    set: { viewModel.activeSetEdit?.values = $0 }
                ),
                headerTitle: viewModel.headerTitle,
                onAddDrop: { viewModel.addDropStep() },
                onDone: {
                    viewModel.saveEditedSet()
                }
            )
            // Use a fixed height so the sheet hugs the content like the system
            // calculator (~452 pt including safe area). On very small screens consider
            // `.fraction(0.52)` instead.
            .presentationDetents([.height(Theme.size.numberPadSheetHeight)])
            .presentationDragIndicator(.visible)
        }
    }

    private var headerSection: some View {
        Section {
            VStack(alignment: .leading, spacing: .zero) {
                Text(
                    String(
                        format: NSLocalizedString("WorkoutSession.Header", comment: "Тренировка для %@"),
                        viewModel.client?.name ?? NSLocalizedString("WorkoutSession.ClientPlaceholder", comment: "Клиента")
                    )
                )
                .font(Theme.font.titleMedium).bold()
                .padding(.vertical, Theme.spacing.compactInnerSpacing)
                if let date = viewModel.session.date {
                    Text("\(date.formatted(date: .long, time: .shortened))")
                        .foregroundColor(Theme.color.textSecondary)
                }
                if let notes = viewModel.session.notes, !notes.isEmpty {
                    Text(notes)
                        .font(Theme.font.body)
                        .foregroundColor(Theme.color.accent)
                        .padding(.top, Theme.spacing.small)
                }
            } //: VStack
        } //: Section
    }

    @ViewBuilder
    private func workoutSection(_ section: WorkoutSection, exercises: [ExerciseInstance]) -> some View {
        if !exercises.isEmpty {
            Section {
                ForEach(exercises, id: \.id) { ex in
                    if let group = viewModel.group(for: ex) {
                        if group.type == .superset {
                            let first = viewModel.isFirstExerciseInGroup(ex)
                            let last = viewModel.isLastExerciseInGroup(ex)
                            WorkoutExerciseRowView(
                                exercise: ex,
                                group: group,
                                onEdit: { viewModel.editItemTapped(withId: group.id) },
                                onDelete: { viewModel.deleteItem(withId: group.id) },
                                onSetEdit: { ex, setId in
                                    viewModel.editSet(withID: setId, ofExercise: ex.id)
                                },
                                onAddSet: { ex in
                                    viewModel.addSet(toExercise: ex.id)
                                },
                                isLocked: viewModel.session.status == .completed || viewModel.session.status == .cancelled,
                                initiallyExpanded: false,
                                isFirstInGroup: first,
                                isLastInGroup: last,
                                isGrouped: true
                            )
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(
                                top: first ? Theme.current.spacing.compactSetRowSpacing : 0,
                                leading: 8,
                                bottom: last ? Theme.spacing.compactSetRowSpacing : 0,
                                trailing: 8
                            ))
                        } else if viewModel.isFirstExerciseInGroup(ex) {
                            let groupExercises = viewModel.groupExercises(for: group)
                            WorkoutExerciseRowView(
                                exercise: ex,
                                group: group,
                                groupExercises: groupExercises,
                                onEdit: { viewModel.editItemTapped(withId: group.id) },
                                onDelete: { viewModel.deleteItem(withId: group.id) },
                                onSetEdit: { ex, setId in
                                    viewModel.editSet(withID: setId, ofExercise: ex.id)
                                },
                                onAddSet: { ex in
                                    viewModel.addSet(toExercise: ex.id)
                                },
                                isLocked: viewModel.session.status == .completed || viewModel.session.status == .cancelled,
                                initiallyExpanded: viewModel.expandedGroupId == group.id
                            )
                            .onAppear {
                                if viewModel.expandedGroupId == group.id {
                                    viewModel.expandedGroupId = nil
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(
                                top: Theme.current.spacing.compactSetRowSpacing,
                                leading: 8,
                                bottom: Theme.spacing.compactSetRowSpacing,
                                trailing: 8
                            ))
                        }
                    } else {
                        WorkoutExerciseRowView(
                            exercise: ex,
                            group: nil,
                            onEdit: { viewModel.editItemTapped(withId: ex.id) },
                            onDelete: { viewModel.deleteItem(withId: ex.id) },
                            onSetEdit: { ex, setId in
                                viewModel.editSet(withID: setId, ofExercise: ex.id)
                            },
                            onAddSet: { ex in
                                viewModel.addSet(toExercise: ex.id)
                            },
                            isLocked: viewModel.session.status == .completed || viewModel.session.status == .cancelled
                        )
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(
                            top: Theme.current.spacing.compactSetRowSpacing,
                            leading: 8,
                            bottom: Theme.spacing.compactSetRowSpacing,
                            trailing: 8
                        ))
                    }
                }
            } header: {
                WorkoutSectionHeaderView(title: section.displayTitle)
            }
        }
    }
}


#Preview("Default Light") {
    Theme.layoutMode = .regular
    return NavigationStack {
        WorkoutSessionView(session: MockData.complexMockSessions[15], client: clientsMock[0], store: WorkoutStore())
    }
}

#Preview("Compact Light") {
    Theme.layoutMode = .compact
    return NavigationStack {
        WorkoutSessionView(session: MockData.complexMockSessions[15], client: clientsMock[0], store: WorkoutStore())
    }
}

#Preview("Compact Dark") {
    Theme.layoutMode = .compact
    return NavigationStack {
        WorkoutSessionView(session: MockData.complexMockSessions[15], client: clientsMock[0], store: WorkoutStore())
    }
    .preferredColorScheme(.dark)
}
