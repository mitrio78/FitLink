import SwiftUI

import SwiftUI

struct TrainerDashboardView: View {
    @StateObject private var viewModel = TrainerDashboardViewModel()
    @State private var showFilterDialog = false
    @State private var selectedFilter: FilterType = .none

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Header
                HStack {
                    Text("Привет, Юрий!")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(.label))
                    Spacer()
                    Button(action: {}) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell")
                                .font(.title2)
                                .foregroundColor(Color(.secondaryLabel))
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 8, height: 8)
                                .offset(x: 7, y: -7)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 36)
                
                // Stats tiles
                HStack(spacing: 12) {
                    ForEach(viewModel.clientStats) { stat in
                        StatSummaryCard(stat: stat)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                // Search bar with filter
                SearchBarWithFilter(
                    text: $viewModel.searchText,
                    placeholder: "Поиск клиента...",
                    onFilterTapped: { showFilterDialog = true }
                )
                .confirmationDialog("Фильтровать по", isPresented: $showFilterDialog, titleVisibility: .visible) {
                    ForEach(FilterType.allCases) { filter in
                        Button(filter.rawValue) {
                            selectedFilter = filter
                            viewModel.applyFilter(filter)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 4)
                
                // Clients list
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.filteredClients) { client in
                            ClientRow(
                                client: client,
                                lastSession: viewModel.lastSession(for: client),
                                nextSession: viewModel.nextSession(for: client)
                            )
                            .padding(.horizontal, 4)
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .background(Color(.systemBackground).ignoresSafeArea())
            .simultaneousGesture(
                TapGesture().onEnded { _ in
                    hideKeyboard()
                }
            )
            .navigationBarHidden(true)
        }
    }
}

enum FilterType: String, CaseIterable, Identifiable {
    case none = "Очистить фильтр"
    case nextSessionDate = "По дате следующей тренировки"
    case nextSessionType = "По типу тренировки"
    var id: String { rawValue }
}

#Preview {
    TrainerDashboardView()
}
