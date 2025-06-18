import SwiftUI

/// Row used in workout lists which can expand to show superset contents.
struct WorkoutExerciseRowView<Content: View>: View {
    let title: String
    let isSuperset: Bool
    @ViewBuilder let content: Content

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small) {
            HStack {
                Text(title)
                    .font(Theme.font.subheading)
                    .foregroundColor(Theme.color.textPrimary)
                Spacer()
                if isSuperset {
                    Button(action: toggle) {
                        Image(systemName: "chevron.right")
                            .rotationEffect(.degrees(isExpanded ? 90 : 0))
                            .foregroundColor(Theme.color.textSecondary)
                    }
                    .buttonStyle(.borderless)
                    .animation(.easeInOut, value: isExpanded)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: toggle)

            if isSuperset {
                content
                    .opacity(isExpanded ? 1 : 0)
                    .frame(maxHeight: isExpanded ? .infinity : 0, alignment: .top)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .clipped()
            }
        }
        .padding(Theme.spacing.medium)
        .background(Theme.color.backgroundSecondary)
        .cornerRadius(Theme.radius.card)
        .animation(.easeInOut, value: isExpanded)
    }

    private func toggle() {
        isExpanded.toggle()
    }
}

#if DEBUG
struct WorkoutExerciseRowView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutExerciseRowView(title: "Superset", isSuperset: true) {
            VStack(alignment: .leading) {
                Text("Push Ups")
                Text("Pull Ups")
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
