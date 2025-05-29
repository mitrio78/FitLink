//
//  ExerciseRow.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI

struct ExerciseRow: View {
    let exercise: Exercise

    var body: some View {
        HStack {
            Image(systemName: exercise.thumbnailName ?? exercise.type.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .padding(6)
                .background(Color(.systemGray5))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(exercise.name).font(.body.bold())
                Text("\(exercise.muscleGroup) • \(exercise.equipment)")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack(spacing: 4) {
                    ForEach(exercise.variations, id: \.self) { variation in
                        if variation != .none {
                            VariationBadge(variation: variation)
                        }
                    }
                }
            }
            .padding(.leading, 8)
            
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color(.systemGray4).opacity(0.15), radius: 2, x: 0, y: 1)
    }
}

// Preview для UI атома
struct ExerciseRow_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRow(exercise: .mockData[1])
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
