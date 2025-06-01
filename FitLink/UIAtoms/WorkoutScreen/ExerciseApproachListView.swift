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
        if let _ = exerciseInstance.groupId {
            DropSetView(
                exercise: exerciseInstance,
                approaches: [DropSetApproach(steps: [approach.set] + approach.drops)]
            )
        } else {
            ApproachSetView(
                set: approach.set,
                index: index,
                metrics: exerciseInstance.exercise.metrics
            )
        }
    }
}
