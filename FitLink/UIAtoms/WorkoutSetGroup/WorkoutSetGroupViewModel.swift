//
//  WorkoutSetGroupViewModel.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 31.05.2025.
//

import SwiftUI

class WorkoutSetGroupViewModel: ObservableObject {
    let group: SetGroup
    let allExercises: [ExerciseInstance]

    var supersetApproaches: [SupersetApproach] = []
    var dropsetApproaches: [DropSetApproach] = []
    var dropsetExercise: ExerciseInstance? = nil
    var regularExercises: [ExerciseInstance] = []

    init(group: SetGroup, allExercises: [ExerciseInstance]) {
        self.group = group
        self.allExercises = allExercises
        prepareData()
    }

    private func prepareData() {
        switch group.type {
        case .superset:
            self.supersetApproaches = makeSupersetApproaches(group: group, allExercises: allExercises)

            case .dropset:
                if let exId = group.exerciseInstanceIds.first,
                   let ex = allExercises.first(where: { $0.id == exId }) {
                    self.dropsetApproaches = makeDropSetApproaches(for: ex)
                    self.dropsetExercise = ex
                }

        default:
            self.regularExercises = group.exerciseInstanceIds.compactMap { id in
                allExercises.first(where: { $0.id == id })
            }
        }
    }
}
