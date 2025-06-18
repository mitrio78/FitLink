import SwiftUI

struct TrainerDashboardView: View {
    @StateObject private var viewModel = TrainerDashboardViewModel()
    @State private var showFilterDialog = false
    @State private var selectedFilter: FilterType = .none

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.spacing.medium) {
                // Header
                HStack {
                    Text(NSLocalizedString("Dashboard.Greeting", comment: "Привет, Юрий!"))
                        .font(Theme.font.titleMedium).bold()
                        .foregroundColor(Theme.color.textPrimary)
                    Spacer()
                    Button(action: {}) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell")
                                .font(Theme.font.titleSmall)
                                .foregroundColor(Theme.color.textSecondary)
                            Circle()
                                .fill(Theme.color.accent)
                                .frame(width: Theme.spacing.small, height: Theme.spacing.small)
                                .offset(x: 7, y: -7)
                        }
                    }
                }
                .padding(.horizontal, Theme.spacing.medium)
                .padding(.top, Theme.spacing.extraLarge + 4)
                
                // Stats tiles
                HStack(spacing: Theme.spacing.small + 4) {
                    ForEach(viewModel.clientStats) { stat in
                        StatSummaryCard(stat: stat)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, Theme.spacing.medium)
                .padding(.bottom, Theme.spacing.small)
                
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
                .padding(.horizontal, Theme.spacing.medium)
                .padding(.bottom, Theme.spacing.small / 2)
                
                // Clients list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredClients) { client in
                            ClientRow(
                                client: client,
                                lastSession: viewModel.lastSession(for: client),
                                nextSession: viewModel.nextSession(for: client)
                            )
                            .padding(.horizontal, Theme.spacing.medium)
                        }
                    }
                    .padding(.top, Theme.spacing.small)
                }
            }
            .background(Theme.color.background.ignoresSafeArea())
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
