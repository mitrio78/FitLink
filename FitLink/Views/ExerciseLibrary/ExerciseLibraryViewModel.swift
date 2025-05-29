//
//  ExerciseLibraryViewModel.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import Foundation
import Combine

final class ExerciseLibraryViewModel: ObservableObject {
    @Published var exercises: [Exercise] = Exercise.mockData
    @Published var searchText: String = ""
    @Published var selectedType: ExerciseType? = nil

    var filteredExercises: [Exercise] {
        exercises.filter { exercise in
            (searchText.isEmpty || exercise.name.lowercased().contains(searchText.lowercased()))
            && (selectedType == nil || exercise.type == selectedType)
        }
    }
    
    func addExercise(_ exercise: Exercise) {
        exercises.append(exercise)
    }
    
    func updateExercise(_ exercise: Exercise) {
        if let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
            exercises[index] = exercise
        }
    }
}
