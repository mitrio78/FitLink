//
//  SuperSetsApproachView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 31.05.2025.
//

import SwiftUI

struct SupersetApproachView: View {
    let index: Int
    let approach: SupersetApproach

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small) {
            HStack {
                Text(String(format: NSLocalizedString("SupersetApproachView.Title", comment: "Подход %d"), index + 1))
                    .font(Theme.font.titleSmall)
                    .foregroundColor(Theme.color.accent)
                Spacer()
            }
            ForEach(approach.exercises) { result in
                HStack(spacing: Theme.spacing.small) {
                    Text(result.exerciseName)
                        .font(Theme.font.body.bold())
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                    Spacer()
                    HStack(spacing: Theme.spacing.small) {
                        ForEach(result.metricValues, id: \.displayName) { metric in
                            HStack(spacing: Theme.spacing.small / 2) {
                                if let icon = metric.iconName {
                                    Image(systemName: icon)
                                        .font(Theme.font.metadata)
                                        .foregroundColor(Theme.color.textSecondary)
                                }
                                Text(metric.value)
                                    .font(Theme.font.body)
                                    .foregroundColor(Theme.color.textPrimary)
                            }
                        }
                    }
                }
                
            }
        }
        .padding()
    }
}

#if DEBUG
struct SupersetApproachView_Previews: PreviewProvider {
    static var previews: some View {
        let metrics = [MetricValue(type: .reps, displayName: "повт.", value: "10", iconName: "arrow.2.squarepath"), MetricValue(type: .weight, displayName: "кг", value: "50", iconName: "scalemass")]
        let ex1 = ExerciseResult(exerciseName: "Сгибания рук", metricValues: metrics)
        let ex2 = ExerciseResult(exerciseName: "Тяга штанги", metricValues: metrics)
        let approach = SupersetApproach(exercises: [ex1, ex2])
        SupersetApproachView(index: 0, approach: approach)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
