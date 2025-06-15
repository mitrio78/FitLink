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
                set: approach.setWithDrops,
                index: index,
                metrics: exerciseInstance.exercise.metrics
            )
        }
    }
}

#if DEBUG
struct ExerciseApproachListView_Previews: PreviewProvider {
    static var previews: some View {
        let metrics = [ExerciseMetric(type: .reps, isRequired: true), ExerciseMetric(type: .weight, isRequired: false)]
        let set = ExerciseSet(id: UUID(), metricValues: [.reps: 10, .weight: 50], notes: nil, drops: nil)
        let approach = Approach(set: set, drops: [])
        let exercise = ExerciseInstance(id: UUID(), exercise: Exercise(id: UUID(), name: "Становая тяга", description: "", mediaURL: nil, variations: [], muscleGroups: [], metrics: metrics), approaches: [approach, approach], groupId: nil, notes: nil)
        ExerciseApproachListView(exerciseInstance: exercise)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
