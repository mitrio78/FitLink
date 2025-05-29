//
//  ExerciseLibraryViewModel.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import Foundation
import Combine

import SwiftUI

final class ExerciseLibraryViewModel: ObservableObject {
    @Published var exercises: [Exercise] = Exercise.mockData
    @Published var searchText: String = ""
    @Published var selectedCategory: ExerciseCategory? = nil

    var filteredExercises: [Exercise] {
        exercises.filter { exercise in
            (selectedCategory == nil || exercise.category == selectedCategory!) &&
            (searchText.isEmpty || exercise.name.localizedCaseInsensitiveContains(searchText))
        }
    }
}
