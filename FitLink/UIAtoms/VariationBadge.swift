//
//  VariationBadge.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//
import SwiftUI

struct VariationBadge: View {
    let variation: String

    var body: some View {
        Text(variation)
            .font(Theme.font.metadata)
            .foregroundColor(.white)
            .padding(.horizontal, Theme.spacing.small)
            .padding(.vertical, Theme.spacing.small / 4)
            .background(Theme.color.accent.opacity(0.75))
            .clipShape(Capsule())
    }
}

#if DEBUG
struct VariationBadge_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VariationBadge(variation: "Классический")
        } //: VStack
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
