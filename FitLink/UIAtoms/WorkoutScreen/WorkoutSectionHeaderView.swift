import SwiftUI

/// Section header used on the Workout screen
struct WorkoutSectionHeaderView: View {
    let title: String
    var body: some View {
        Text(title)
            .font(Theme.font.subheading)
            .foregroundColor(Theme.color.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack {
        WorkoutSectionHeaderView(title: "Warm-up")
        Spacer()
    }
    .padding()
}
