import SwiftUI

/// Text-only button used throughout the Workout screen
struct WorkoutActionButton: View {
    let label: String
    var color: Color = Theme.color.accent
    var filled: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Theme.font.body)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, Theme.spacing.small)
                .foregroundColor(filled ? .white : color)
                .background(filled ? color : Color.clear)
                .cornerRadius(Theme.radius.button)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    WorkoutActionButton(label: "Add Exercise", action: {})
        .padding()
}
