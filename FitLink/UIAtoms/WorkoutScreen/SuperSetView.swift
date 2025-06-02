//
//  Untitled.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 30.05.2025.
//

import Foundation
import SwiftUI

struct SuperSetView: View {
    let sets: [SupersetApproach]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(sets.enumerated()), id: \.element.id) { (index, approach) in
                SupersetApproachView(index: index, approach: approach)
            }
        }
    }
}

#if DEBUG
struct SuperSetView_Previews: PreviewProvider {
    static var previews: some View {
        let metrics = [MetricValue(type: .reps, displayName: "повт.", value: "10", iconName: "arrow.2.squarepath"), MetricValue(type: .weight, displayName: "кг", value: "50", iconName: "scalemass")]
        let ex1 = ExerciseResult(exerciseName: "Сгибания рук", metricValues: metrics)
        let ex2 = ExerciseResult(exerciseName: "Тяга штанги", metricValues: metrics)
        let approach = SupersetApproach(exercises: [ex1, ex2])
        SuperSetView(sets: [approach])
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
