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
        HStack(alignment: .center, spacing: 14) {
            Image(systemName: exercise.category.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(exercise.category.color)
                .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 7) {
                Text(exercise.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                // Категория — Capsule
                HStack(spacing: 6) {
                    Image(systemName: exercise.category.iconName)
                        .font(.system(size: 12))
                        .foregroundColor(exercise.category.color)
                    Text(exercise.category.rawValue)
                        .font(.caption.bold())
                        .foregroundColor(exercise.category.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(exercise.category.color.opacity(0.08))
                        .clipShape(Capsule())
                }

                if !exercise.variations.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(exercise.variations) { variation in
                                VariationBadge(variation: variation)
                            }
                        }
                        .padding(.top, 2)
                    }
                }
            }
            .padding(.vertical, 6)
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 1, x: 0, y: 1)
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
