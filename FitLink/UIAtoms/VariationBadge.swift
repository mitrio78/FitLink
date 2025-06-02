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
            .font(.caption2)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(Color.accentColor.opacity(0.75))
            .clipShape(Capsule())
    }
}

#if DEBUG
struct VariationBadge_Previews: PreviewProvider {
    static var previews: some View {
        VariationBadge(variation: "Классический")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
