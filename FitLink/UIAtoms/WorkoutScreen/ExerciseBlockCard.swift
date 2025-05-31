//
//  ExerciseBlockCard.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 31.05.2025.
//
import SwiftUI

struct ExerciseBlockCard: View {
    let exerciseInstance: ExerciseInstance

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(exerciseInstance.exercise.name)
                .font(.headline)
                .padding(.bottom, 2)
            ExerciseApproachListView(exerciseInstance: exerciseInstance)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
        .shadow(color: Color(.black).opacity(0.03), radius: 3, x: 0, y: 1)
    }
}
