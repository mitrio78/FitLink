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
