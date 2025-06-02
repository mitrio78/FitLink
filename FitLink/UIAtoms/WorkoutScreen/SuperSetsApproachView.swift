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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Подход \(index + 1)")
                    .font(.headline)
                    .foregroundColor(Color.blue)
                Spacer()
                // Мини-иконка или progress-dot, если хочется визуального акцента
                Circle()
                    .fill(Color.blue)
                    .frame(width: 10, height: 10)
            }
            ForEach(approach.exercises) { result in
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.exerciseName)
                        .font(.body.bold())
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                    HStack(spacing: 16) {
                        ForEach(result.metricValues, id: \.displayName) { metric in
                            HStack(spacing: 4) {
                                if let icon = metric.iconName {
                                    Image(systemName: icon)
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                }
                                Text(metric.value)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                .padding(.bottom, 4)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
                .shadow(color: Color(.black).opacity(0.04), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.blue.opacity(0.17), lineWidth: 1)
        )
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
