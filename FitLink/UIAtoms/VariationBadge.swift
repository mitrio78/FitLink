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
        switch variation {
        case .superset: return .blue
        case .dropset: return .orange
        case .triset: return .green
        case .circuit: return .purple
        default: return .gray
        }
    }

    var body: some View {
        Text(variation.rawValue)
            .font(.caption2.bold())
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}

