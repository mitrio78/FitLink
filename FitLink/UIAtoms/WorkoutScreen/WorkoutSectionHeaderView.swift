import SwiftUI

/// Section header used on the Workout screen
struct WorkoutSectionHeaderView: View {
    let title: String
    var body: some View {
        Text(title)
            .font(Theme.font.subheading)
            .foregroundColor(Theme.color.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, Theme.spacing.large)
            .padding(.bottom, Theme.spacing.medium)
    }
}

#Preview {
    VStack {
        WorkoutSectionHeaderView(title: "Warm-up")
        Spacer()
    }
    .padding()
    .previewLayout(.sizeThatFits)
}
