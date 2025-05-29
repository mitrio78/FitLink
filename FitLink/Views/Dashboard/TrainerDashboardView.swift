import SwiftUI

struct TrainerDashboardView: View {
    @StateObject private var viewModel = TrainerDashboardViewModel()
    @State private var showFilterDialog = false
    @State private var selectedFilter: FilterType = .none
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                // Header
                HStack {
                    Text("Физкульт привет!")
                        .font(.system(size: 22, weight: .bold))
                        .padding(.vertical)
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "bell")
                            .font(.title2)
                            .overlay(
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 8, y: -8),
                                alignment: .topTrailing
                            )
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Stats
                HStack(spacing: 12) {
                    ForEach(viewModel.clientStats) { stat in
                        StatSummaryCard(stat: stat)
                    }
                }
                .padding(.horizontal)
                
                SearchBarWithFilter(
                    text: $viewModel.searchText,
                    placeholder: "Поиск клиента...",
                    onFilterTapped: {
                        showFilterDialog = true
                    }
                )
                .confirmationDialog("Фильровать по", isPresented: $showFilterDialog, titleVisibility: .visible) {
                    ForEach(FilterType.allCases) { filter in
                        Button(filter.rawValue) {
                            selectedFilter = filter
                            viewModel.applyFilter(filter)
                        }
                    }
                }
                .padding(.horizontal)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredClients) { client in
                            ClientRow(client: client)
                        }
                    }
                    .padding()
                }
            }
            .simultaneousGesture(
                TapGesture().onEnded { _ in
                    hideKeyboard()
                }
            )
            .background(Color(.systemBackground))
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
