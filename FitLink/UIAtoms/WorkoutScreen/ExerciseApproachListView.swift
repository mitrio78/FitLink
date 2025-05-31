//
//  У.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 31.05.2025.
//

import SwiftUI

struct ExerciseApproachListView: View {
    let exerciseInstance: ExerciseInstance   // <--- добавь сюда!

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(exerciseInstance.approaches.enumerated()), id: \.offset) { index, approach in
                approachView(approach: approach, index: index)
            }
        }
    }

    @ViewBuilder
    private func approachView(approach: Approach, index: Int) -> some View {
        switch approach {
        case .regular(let set):
            ApproachSetView(set: set, index: index, metrics: exerciseInstance.exercise.metrics)
        case .dropset(let steps):
            DropSetView(
                exercise: exerciseInstance, // теперь в scope!
                approaches: [DropSetApproach(steps: steps)]
            )
        }
    }
}
