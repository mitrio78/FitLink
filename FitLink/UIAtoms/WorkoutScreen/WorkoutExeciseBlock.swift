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
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(exerciseInstance.exercise.name)
                    .font(.headline)
                Spacer()
                // например, иконка "развернуть" для перехода к редактированию
            }
            ExerciseApproachListView(exerciseInstance: exerciseInstance)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
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
