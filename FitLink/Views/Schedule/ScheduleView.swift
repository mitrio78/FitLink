//
//  ClientsView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//
import SwiftUI

struct ScheduleView: View {
    @StateObject private var viewModel = ScheduleViewModel()
    @State private var selectedSession: WorkoutSession?
    @EnvironmentObject private var store: WorkoutStore

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header с кнопками режимов справа
                HStack {
                    Spacer()
                    Text(NSLocalizedString("Schedule.Header", comment: "Занятия"))
                        .font(Theme.font.titleMedium).bold()
                    Spacer()
                    HStack(spacing: Theme.spacing.medium) {
                        Button(action: {
                            withAnimation { viewModel.isCalendarMode = true }
                        }) {
                            Image(systemName: "calendar")
                                .font(Theme.font.titleLarge)
                                .foregroundColor(viewModel.isCalendarMode ? Theme.color.accent : Theme.color.textSecondary)
                                .padding(Theme.spacing.small)
                                .background(viewModel.isCalendarMode ? Theme.color.backgroundSecondary : Color.clear)
                                .clipShape(Circle())
                        }
                        Button(action: {
                            withAnimation { viewModel.isCalendarMode = false }
                        }) {
                            Image(systemName: "checklist.checked")
                                .font(Theme.font.titleLarge)
                                .foregroundColor(!viewModel.isCalendarMode ? Theme.color.accent : Theme.color.textSecondary)
                                .padding(Theme.spacing.small)
                                .background(!viewModel.isCalendarMode ? Theme.color.backgroundSecondary : Color.clear)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.horizontal, Theme.spacing.medium)
                .padding(.top, Theme.spacing.medium - 4)
                .padding(.bottom, Theme.spacing.small)
                
                // Search
                SearchBarWithFilter(
                    text: $viewModel.searchText,
                    placeholder: NSLocalizedString("Schedule.SearchPlaceholder", comment: "Search clients..."),
                    onFilterTapped: {
                        // Тут future: фильтр по статусу, тренеру и т.д.
                    }
                )
                .padding(.horizontal, Theme.spacing.medium)
                .padding(.bottom, Theme.spacing.medium)
                
                
                Divider()
                    .padding(.bottom, Theme.spacing.medium)
                
                ScrollView {
                    // Content
                    if viewModel.isCalendarMode {
                        ScheduleCalendarContainer(
                            viewModel: viewModel,
                            selectedSession: $selectedSession,
                            clients: viewModel.clients
                        )
                        .padding(.bottom, Theme.spacing.small)
                    } else {
                        ListModeView(
                            todaySessions: viewModel.todaySessions,
                            clients: viewModel.clients,
                            selectedSession: $selectedSession
                        )
                        .padding(.bottom, Theme.spacing.small)
                    }
                }
            }
            .simultaneousGesture(
                TapGesture().onEnded { _ in hideKeyboard() }
            )
            .background(Theme.color.background)
            .navigationDestination(item: $selectedSession) { session in
                let client = session.clientId.flatMap { viewModel.clients[$0] }
                WorkoutSessionView(session: session, client: client, store: store)
            }
            .navigationBarHidden(true)
            
        }
    }
}

#Preview {
    ScheduleView()
        .environmentObject(WorkoutStore())
}
