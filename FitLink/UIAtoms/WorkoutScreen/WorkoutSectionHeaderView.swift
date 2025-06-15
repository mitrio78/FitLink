import SwiftUI

/// Section header used on the Workout screen
struct WorkoutSectionHeaderView: View {
    let title: String
    var body: some View {
        Divider()
        Text(title)
            .font(Theme.font.subheading)
            .foregroundColor(Theme.color.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, Theme.spacing.small)
            .padding(.bottom, Theme.spacing.small)
            .padding(.leading, Theme.spacing.small)
    }
}

#Preview {
    VStack {
        WorkoutSectionHeaderView(title: "Warm-up")
        Spacer()
    }
    .padding()
}
