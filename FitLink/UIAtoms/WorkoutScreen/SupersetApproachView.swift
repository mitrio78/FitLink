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

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small) {
            Text(String(format: NSLocalizedString("SupersetApproachView.Title", comment: "Approach %d"), index))
                .font(Theme.font.body.bold())
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                VStack(alignment: .leading, spacing: Theme.spacing.small / 2) {
                    Text(item.exercise.exercise.name)
                        .font(Theme.font.body).bold()
                    ExerciseSetMetricsView(
                        sets: [approachSet(from: item.approach)],
                        metrics: item.exercise.exercise.metrics
                    )
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
