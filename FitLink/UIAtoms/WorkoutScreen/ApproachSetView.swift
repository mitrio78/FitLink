//
//  ApproachSetView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 31.05.2025.
//

import SwiftUI

struct ApproachSetView: View {
    let set: ExerciseSet
    let index: Int
    let metrics: [ExerciseMetric]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small / 2) {
            // Основной сет
            HStack {
                Text(String(format: NSLocalizedString("ApproachSetView.Title", comment: "Подход %d:"), index + 1))
                    .font(Theme.font.body)
                    .foregroundColor(.primary)
                Spacer()
                ForEach(metrics, id: \.type) { metric in
                    if let value = set.metricValues[metric.type] {
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

            // Дропы, если есть
            if let drops = set.drops, !drops.isEmpty {
                ForEach(Array(drops.enumerated()), id: \.element.id) { i, drop in
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
        let set = ExerciseSet(id: UUID(), metricValues: [.reps: 10, .weight: 50], notes: nil, drops: [.init(id: UUID(), metricValues: [.reps:2])])
        ApproachSetView(set: set, index: 0, metrics: metrics)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
