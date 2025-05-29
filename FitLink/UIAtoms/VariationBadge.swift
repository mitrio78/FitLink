//
//  VariationBadge.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//
import SwiftUI

struct VariationBadge: View {
    let variation: ExerciseVariation

    var color: Color {
        switch variation.name.lowercased() {
        case "суперсет", "superset": return .blue
        case "дроп-сет", "дропсет", "dropset": return .orange
        case "трисет", "triset": return .green
        case "круговая", "circuit": return .purple
        default: return .gray
        }
    }

    var body: some View {
        Text(variation.name)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.13))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}
