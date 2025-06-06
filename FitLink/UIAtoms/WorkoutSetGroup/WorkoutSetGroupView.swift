//
//  WorkoutSetGroup.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 30.05.2025.
//

import SwiftUI

struct WorkoutSetGroupView: View {
    @ObservedObject var viewModel: WorkoutSetGroupViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Шапка группы
            HStack(spacing: 8) {
                Image(systemName: viewModel.group.type.iconName)
                    .foregroundColor(viewModel.group.type.color)
                    .font(.title3)
                Text(viewModel.group.type.displayName)
                    .font(.headline.bold())
                    .foregroundColor(viewModel.group.type.color)
                if let reps = viewModel.group.repeatCount, reps > 1 {
                    Text(String(format: NSLocalizedString("WorkoutSetGroup.RepsMultiplier", comment: "×%d"), reps))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.leading, 6)
                }
                Spacer()
            }
            .padding(.vertical, 2)
            
            // Тело группы (правильно!)
            switch viewModel.group.type {
            case .superset:
                if !viewModel.supersetApproaches.isEmpty {
                    SuperSetView(sets: viewModel.supersetApproaches)
                } else {
                    Text(NSLocalizedString("WorkoutSetGroup.EmptySuperset", comment: "Нет подходов в суперсете"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            case .dropset:
                if let exercise = viewModel.dropsetExercise,
                   !viewModel.dropsetApproaches.isEmpty {
                    DropSetView(
                        exercise: exercise,
                        approaches: viewModel.dropsetApproaches
                    )
                } else {
                    Text(NSLocalizedString("WorkoutSetGroup.EmptyDropset", comment: "Нет дропсета"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            default:
                VStack(spacing: 8) {
                    ForEach(viewModel.regularExercises, id: \.id) { instance in
                        ExerciseBlockCard(
                            group: nil,
                            exerciseInstances: [instance]
                        )
                        .padding(.vertical, 2)
                    }
                }
                .padding(.leading, 4)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(viewModel.group.type.color.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(viewModel.group.type.color.opacity(0.65), lineWidth: 1.1)
        )
        .shadow(color: viewModel.group.type.color.opacity(0.07), radius: 8, x: 0, y: 3)
        .padding(.vertical, 4)
    }
}
