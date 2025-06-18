//
//  Untitled.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 16.06.2025.
//
import SwiftUI

/// View representing a single approach in the superset.
struct SupersetApproachView: View {
    let index: Int
    let items: [(exercise: ExerciseInstance, approach: Approach)]
    var onSetsEdit: (ExerciseInstance) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small) {
            Text(String(format: NSLocalizedString("SupersetApproachView.Title", comment: "Approach %d"), index))
                .font(Theme.font.subheading.bold())
                .foregroundColor(Theme.color.accent)
            ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                if idx > 0 {
                    Divider()
                        .background(Theme.color.border.opacity(0.3))
                }
                VStack(alignment: .leading, spacing: Theme.spacing.small / 2) {
                    Text(item.exercise.exercise.name)
                        .font(Theme.font.body).bold()
                    Button(action: { onSetsEdit(item.exercise) }) {
                        ApproachCardView(set: approachSet(from: item.approach), metrics: item.exercise.exercise.metrics)
                            .frame(height: 64)
                    }
                }
            }
        }
    }

    private func approachSet(from approach: Approach) -> ExerciseSet {
        var first = approach.sets.first ?? ExerciseSet(id: UUID(), metricValues: [:], notes: nil, drops: nil)
        first.drops = Array(approach.sets.dropFirst())
        return first
    }
}
