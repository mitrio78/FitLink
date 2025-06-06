//
//  WorkoutSessionBlock.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//

import SwiftUI

struct WorkoutExerciseRow: View {
    let exerciseInstance: ExerciseInstance

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small + 2) {
            HStack {
                Text(exerciseInstance.exercise.name)
                    .font(Theme.font.titleSmall)
                Spacer()
                // например, иконка "развернуть" для перехода к редактированию
            }
            ExerciseApproachListView(exerciseInstance: exerciseInstance)
        }
        .padding(Theme.spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: Theme.radius.card)
                .fill(Theme.color.backgroundSecondary)
        )
        .onTapGesture {
            // открыть details или editor
        }
    }
}

#if DEBUG
struct WorkoutExerciseRow_Previews: PreviewProvider {
    static var previews: some View {
        let metrics = [ExerciseMetric(type: .reps, isRequired: true), ExerciseMetric(type: .weight, isRequired: false)]
        let set = ExerciseSet(id: UUID(), metricValues: [.reps: 10, .weight: 50], notes: nil, drops: nil)
        let approach = Approach(set: set, drops: [])
        let exercise = ExerciseInstance(id: UUID(), exercise: Exercise(id: UUID(), name: "Становая тяга", description: "", mediaURL: nil, variations: [], muscleGroups: [], metrics: metrics), approaches: [approach, approach], groupId: nil, notes: nil)
        WorkoutExerciseRow(exerciseInstance: exercise)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
