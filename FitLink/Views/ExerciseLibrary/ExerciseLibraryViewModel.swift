//
//  ExerciseLibraryViewModel.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import Foundation
import Combine

@MainActor
final class ExerciseLibraryViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var searchText: String = ""
    @Published var selectedMuscleGroup: MuscleGroup? = nil
    private let dataStore: AppDataStore

    init(dataStore: AppDataStore) {
        self.dataStore = dataStore

        dataStore.$exercises
            .assign(to: &$exercises)
    }

    var filteredExercises: [Exercise] {
        exercises.filter { exercise in
            let matchesGroup = selectedMuscleGroup == nil
                || exercise.muscleGroups.contains(selectedMuscleGroup!)
            let matchesSearch = searchText.isEmpty
                || exercise.name.localizedCaseInsensitiveContains(searchText)
                || exercise.muscleGroups
                    .map { $0.displayName.lowercased() }
                    .contains(where: { $0.contains(searchText.lowercased()) })
            return matchesGroup && matchesSearch
        }
    }
}
