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
    let metrics: [ExerciseMetric] // Метаданные для форматирования/иконок

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Номер сета (можно заменить на точку/иконку — на твой вкус)
            Text("Подход \(index + 1):")
                .font(.subheadline)
                .foregroundColor(.primary)
                // .frame(width: 65, alignment: .leading)
            Spacer()
            // Метрики с иконками и значениями
            ForEach(metrics, id: \.type) { metric in
                if let rawValue = set.metricValues[metric.type] {
                    HStack(spacing: 4) {
                        if let iconName = metric.iconName {
                            Image(systemName: iconName)
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        Text(ExerciseMetric.formattedMetric(rawValue, metric: metric))
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
        // Можно добавить небольшой фон, если хочется выделить (например, цвет или Capsule)
    }
}
