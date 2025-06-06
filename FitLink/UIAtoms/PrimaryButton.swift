import SwiftUI

/// Full-width primary action button
struct PrimaryButton: View {
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Theme.font.titleSmall)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Theme.spacing.medium)
                .background(Theme.color.accent)
                .cornerRadius(Theme.radius.button)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PrimaryButton(title: NSLocalizedString("WorkoutSession.AddExercise", comment: "")) {}
        .padding()
        .previewLayout(.sizeThatFits)
}
