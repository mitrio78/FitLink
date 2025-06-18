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
    let items: [(exercise: ExerciseInstance, approach: Approach?)]
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
                    ApproachListView(
                        sets: item.approach?.sets ?? [],
                        metrics: item.exercise.exercise.metrics,
                        onTap: { onSetsEdit(item.exercise) }
                    )
                }
            }
        }
    }

}
