//
//  WorkoutSessionView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//
import SwiftUI
import UniformTypeIdentifiers

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

            workoutSection(.warmUp)
            workoutSection(.main)
            workoutSection(.coolDown)
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
            WorkoutExerciseEditView(
                initialExercises: viewModel.editingContext?.exercises ?? [],
                initialSection: viewModel.editingContext?.instances.first?.section ?? .main
            ) { result in
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
                onAddSet: { viewModel.addNextSet() },
                onDone: {
                    viewModel.saveEditedSet()
                },
                onDelete: viewModel.canDeleteActiveSet ? { viewModel.deleteActiveSet() } : nil
            )
            // Use a fixed height so the sheet hugs the content like the system
            // calculator (~452 pt including safe area). On very small screens consider
            // `.fraction(0.52)` instead.
            .presentationDetents([.height(Theme.size.numberPadSheetHeight)])
            .presentationDragIndicator(.visible)
        }
        .sheet(item: $viewModel.historyExercise) { exercise in
            Text("History for \(exercise.exercise.name)")
                .padding()
        }
        .sheet(item: $viewModel.detailExercise) { exercise in
            Text("Details for \(exercise.exercise.name)")
                .padding()
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
    private func workoutSection(_ section: WorkoutSection) -> some View {
        let rows = viewModel.rows(for: section)
        if !rows.isEmpty {
            Section {
                ForEach(rows) { row in
                    rowView(for: row, in: section)
                        .onDrag {
                            viewModel.startDrag(for: row, in: section)
                            return NSItemProvider(object: NSString(string: row.id))
                        }
                        .onDrop(of: [UTType.text], isTargeted: nil) { _ in
                            viewModel.dropItem(before: row.id, in: section)
                            return true
                        }
                }
                .onMove { indexes, newOffset in
                    viewModel.moveRow(fromOffsets: indexes, toOffset: newOffset, in: section)
                }
            } header: {
                WorkoutSectionHeaderView(title: section.displayTitle)
            }
            .onDrop(of: [UTType.text], isTargeted: nil) { _ in
                viewModel.dropItem(before: nil, in: section)
                return true
            }
        }
    }

    @ViewBuilder
    private func rowView(for row: WorkoutSessionViewModel.RowInfo, in section: WorkoutSection) -> some View {
        if let group = row.group {
            if group.type == .superset {
                WorkoutExerciseRowView(
                    exercise: row.exercise,
                    group: group,
                    onHistory: { viewModel.showHistory(for: row.exercise.id) },
                    onEdit: { viewModel.editItemTapped(withId: group.id) },
                    onDuplicate: { viewModel.duplicateItem(withId: row.exercise.id) },
                    onDetails: { viewModel.showDetails(for: row.exercise.id) },
                    onDelete: {
                        withAnimation { viewModel.deleteExercise(row.exercise.id, fromSuperset: group.id) }
                    },
                    onSetEdit: { ex, setId in viewModel.editSet(withID: setId, ofExercise: ex.id) },
                    onAddSet: { ex in viewModel.addSet(toExercise: ex.id) },
                    isLocked: viewModel.session.status == .completed || viewModel.session.status == .cancelled,
                    initiallyExpanded: false,
                    isFirstInGroup: row.isFirstInGroup,
                    isLastInGroup: row.isLastInGroup,
                    isGrouped: true
                )
                .id(row.id)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                .padding(.top, row.isFirstInGroup ? Theme.current.spacing.compactSetRowSpacing : 0)
                .padding(.bottom, row.isLastInGroup ? Theme.spacing.compactSetRowSpacing : 0)
            } else {
                WorkoutExerciseRowView(
                    exercise: row.exercise,
                    group: group,
                    groupExercises: row.groupExercises,
                    onHistory: { viewModel.showHistory(for: group.id) },
                    onEdit: { viewModel.editItemTapped(withId: group.id) },
                    onDuplicate: { viewModel.duplicateItem(withId: group.id) },
                    onDetails: { viewModel.showDetails(for: group.id) },
                    onDelete: { viewModel.deleteItem(withId: group.id) },
                    onSetEdit: { ex, setId in viewModel.editSet(withID: setId, ofExercise: ex.id) },
                    onAddSet: { ex in viewModel.addSet(toExercise: ex.id) },
                    isLocked: viewModel.session.status == .completed || viewModel.session.status == .cancelled,
                    initiallyExpanded: viewModel.expandedGroupId == group.id
                )
                .onAppear {
                    if viewModel.expandedGroupId == group.id {
                        viewModel.expandedGroupId = nil
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                .padding(.vertical, Theme.spacing.compactSetRowSpacing)
                .id(row.id)
            }
        } else {
            WorkoutExerciseRowView(
                exercise: row.exercise,
                group: nil,
                onHistory: { viewModel.showHistory(for: row.exercise.id) },
                onEdit: { viewModel.editItemTapped(withId: row.exercise.id) },
                onDuplicate: { viewModel.duplicateItem(withId: row.exercise.id) },
                onDetails: { viewModel.showDetails(for: row.exercise.id) },
                onDelete: { viewModel.deleteItem(withId: row.exercise.id) },
                onSetEdit: { ex, setId in viewModel.editSet(withID: setId, ofExercise: ex.id) },
                onAddSet: { ex in viewModel.addSet(toExercise: ex.id) },
                isLocked: viewModel.session.status == .completed || viewModel.session.status == .cancelled
            )
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
            .padding(.vertical, Theme.spacing.compactSetRowSpacing)
            .id(row.id)
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
