//
//  Untitled.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI

struct ExerciseLibraryView: View {
    var onSelect: ((Exercise) -> Void)? = nil

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ExerciseLibraryViewModel(dataStore: .shared)
    @State private var showFilterDialog = false
    @State private var showCreate = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    Text(NSLocalizedString("ExerciseLibrary.Header", comment: "Упражнения"))
                        .font(.title2.bold())
                    Spacer()
                    Button(action: { showCreate = true }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                SearchBarWithFilter(
                    text: $viewModel.searchText,
                    placeholder: NSLocalizedString("ExerciseLibrary.SearchPlaceholder", comment: "Поиск упражнения..."),
                    onFilterTapped: {
                        showFilterDialog = true
                    }
                )
                .padding(.horizontal)
                .confirmationDialog(NSLocalizedString("ExerciseLibrary.FilterTitle", comment: "Выберите группу мышц"), isPresented: $showFilterDialog) {
                    Button(NSLocalizedString("ExerciseLibrary.FilterAll", comment: "Все"), role: .none) { viewModel.selectedMuscleGroup = nil }
                    ForEach(MuscleGroup.allStandardCases, id: \.self) { group in
                        Button(group.displayName) { viewModel.selectedMuscleGroup = group }
                    }
                }

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredExercises) { exercise in
                            if onSelect == nil {
                                NavigationLink(value: exercise.id) {
                                    ExerciseRow(exercise: exercise)
                                }
                                .buttonStyle(.plain)
                            } else {
                                ExerciseRow(exercise: exercise)
                                    .onTapGesture {
                                        onSelect?(exercise)
                                        dismiss()
                                    }
                            }
                        }
                    }
                    .padding()
                }
            }
            .simultaneousGesture(
                TapGesture().onEnded { _ in hideKeyboard() }
            )
            .background(Theme.color.background)
            .navigationBarHidden(true)
            .sheet(isPresented: $showCreate) {
                ExerciseEditView()
            }
            .navigationDestination(for: UUID.self) { id in
                ExerciseDetailView(exerciseId: id)
            }
        }
    }
}

#Preview {
    ExerciseLibraryView()
}
