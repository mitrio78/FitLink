//
//  ApproachSetView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 31.05.2025.
//

import SwiftUI

struct ApproachSetView: View {
    let approach: Approach
    let index: Int
    let metrics: [ExerciseMetric]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small / 2) {
            // Основной сет
            if let mainSet = approach.sets.first {
                HStack {
                    Text(String(format: NSLocalizedString("ApproachSetView.Title", comment: "Подход %d:"), index + 1))
                        .font(Theme.font.body)
                        .foregroundColor(.primary)
                    Spacer()
                    ForEach(metrics, id: \.type) { metric in
                        if let value = mainSet.metricValues[metric.type] {
                            HStack(spacing: Theme.spacing.small / 2) {
                                if let icon = metric.iconName {
                                    Image(systemName: icon)
                                        .font(Theme.font.metadata)
                                        .foregroundColor(.secondary)
                                }
                                Text(ExerciseMetric.formattedMetric(value, metric: metric))
                                    .font(Theme.font.body)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                .padding(.vertical, Theme.spacing.small / 4)
            }

            // Дропы, если есть
            if approach.sets.count > 1 {
                ForEach(Array(approach.sets.dropFirst().enumerated()), id: \.element.id) { i, drop in
                    HStack {
                        Circle()
                            .fill(Theme.color.accent.opacity(0.5))
                            .frame(width: Theme.spacing.small, height: Theme.spacing.small)
                        Text(String(format: NSLocalizedString("ApproachSetView.DropLabel", comment: "Дроп %d:"), i + 1))
                            .font(Theme.font.metadata)
                            .foregroundColor(Theme.color.accent)
                            .frame(width: 60, alignment: .leading)
                        ForEach(metrics, id: \.type) { metric in
                            if let value = drop.metricValues[metric.type] {
                                HStack(spacing: 4) {
                                    if let icon = metric.iconName {
                                        Image(systemName: icon)
                                            .font(Theme.font.metadata)
                                            .foregroundColor(.secondary)
                                    }
                                    Text(ExerciseMetric.formattedMetric(value, metric: metric))
                                        .font(Theme.font.caption)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    .padding(.vertical, Theme.spacing.small / 8)
                }
            }
        }
    }
}

#if DEBUG
struct ApproachSetView_Previews: PreviewProvider {
    static var previews: some View {
        let metrics = [ExerciseMetric(type: .reps, isRequired: true), ExerciseMetric(type: .weight, isRequired: false)]
        let approach = Approach(sets: [
            ExerciseSet(id: UUID(), metricValues: [.reps: 10, .weight: 50], notes: nil, drops: nil),
            ExerciseSet(id: UUID(), metricValues: [.reps: 2], notes: nil, drops: nil)
        ])
        ApproachSetView(approach: approach, index: 0, metrics: metrics)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
