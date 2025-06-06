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
                    Text(NSLocalizedString("Dashboard.Greeting", comment: "Привет, Юрий!"))
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
                    placeholder: NSLocalizedString("Dashboard.SearchPlaceholder", comment: "Поиск клиента..."),
                    onFilterTapped: { showFilterDialog = true }
                )
                    .confirmationDialog(NSLocalizedString("Dashboard.FilterTitle", comment: "Фильтровать по"), isPresented: $showFilterDialog, titleVisibility: .visible) {
                    ForEach(FilterType.allCases) { filter in
                        Button(filter.localized) {
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
                            .padding(.horizontal, 16)
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

    var localized: String {
        switch self {
        case .none:
            return NSLocalizedString("Dashboard.Filter.None", comment: "Очистить фильтр")
        case .nextSessionDate:
            return NSLocalizedString("Dashboard.Filter.NextSessionDate", comment: "По дате следующей тренировки")
        case .nextSessionType:
            return NSLocalizedString("Dashboard.Filter.NextSessionType", comment: "По типу тренировки")
        }
    }
}

#Preview {
    TrainerDashboardView()
}
