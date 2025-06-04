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

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header с кнопками режимов справа
                HStack {
                    Spacer()
                    Text(NSLocalizedString("Schedule.Header", comment: "Занятия"))
                        .font(.title2.bold())
                    Spacer()
                    HStack(spacing: 16) {
                        Button(action: {
                            withAnimation { viewModel.isCalendarMode = true }
                        }) {
                            Image(systemName: "calendar")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(viewModel.isCalendarMode ? .blue : .gray)
                                .padding(8)
                                .background(viewModel.isCalendarMode ? Color(.systemGray6) : Color.clear)
                                .clipShape(Circle())
                        }
                        Button(action: {
                            withAnimation { viewModel.isCalendarMode = false }
                        }) {
                            Image(systemName: "checklist.checked")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(!viewModel.isCalendarMode ? .blue : .gray)
                                .padding(8)
                                .background(!viewModel.isCalendarMode ? Color(.systemGray6) : Color.clear)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 8)
                
                // Search
                SearchBarWithFilter(
                    text: $viewModel.searchText,
                    placeholder: NSLocalizedString("Schedule.SearchPlaceholder", comment: "Search clients..."),
                    onFilterTapped: {
                        // Тут future: фильтр по статусу, тренеру и т.д.
                    }
                )
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                
                Divider()
                    .padding(.bottom, 16)
                
                ScrollView {
                    // Content
                    if viewModel.isCalendarMode {
                        ScheduleCalendarContainer(
                            viewModel: viewModel,
                            selectedSession: $selectedSession,
                            clients: viewModel.clients
                        )
                        .padding(.bottom, 8)
                    } else {
                        ListModeView(
                            todaySessions: viewModel.todaySessions,
                            clients: viewModel.clients,
                            selectedSession: $selectedSession
                        )
                        .padding(.bottom, 8)
                    }
                }
            }
            .simultaneousGesture(
                TapGesture().onEnded { _ in hideKeyboard() }
            )
            .background(Color(.systemBackground))
            .navigationDestination(item: $selectedSession) { session in
                let client = session.clientId.flatMap { viewModel.clients[$0] }
                WorkoutSessionView(session: session, client: client)
            }
            .navigationBarHidden(true)
            
        }
    }
}

#Preview {
    ScheduleView()
}
