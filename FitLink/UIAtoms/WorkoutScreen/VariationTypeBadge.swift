import SwiftUI

struct VariationTypeBadge: View {
    let text: String
    let color: Color
    var body: some View {
        Text(text)
            .font(Theme.font.metadata.bold())
            .padding(.horizontal, Theme.spacing.small)
            .padding(.vertical, Theme.spacing.small / 2)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(Theme.radius.button)
    }
}
