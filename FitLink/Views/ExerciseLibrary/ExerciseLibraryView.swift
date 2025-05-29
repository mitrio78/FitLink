//
//  Untitled.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI
struct ExerciseLibraryView: View {
    @StateObject private var viewModel = ExerciseLibraryViewModel()
    @State private var showFilterDialog = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    Text("Упражнения")
                        .font(.title2.bold())
                    Spacer()
                    Button(action: {
                        // Экран добавления упражнения
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                SearchBarWithFilter(
                    text: $viewModel.searchText,
                    placeholder: "Поиск упражнения...",
                    onFilterTapped: {
                        showFilterDialog = true
                    }
                )
                .padding(.horizontal)
                .confirmationDialog("Выберите категорию", isPresented: $showFilterDialog) {
                    Button("Все", role: .none) { viewModel.selectedCategory = nil }
                    ForEach(ExerciseCategory.allCases) { category in
                        Button(category.rawValue) { viewModel.selectedCategory = category }
                    }
                }

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredExercises) { exercise in
                            ExerciseRow(exercise: exercise)
                                .onTapGesture {
                                    // Переход к деталям упражнения
                                }
                        }
                    }
                    .padding()
                }
            }
            .simultaneousGesture(
                TapGesture().onEnded { _ in hideKeyboard() }
            )
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ExerciseLibraryView()
}
