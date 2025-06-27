import SwiftUI

/// Minimal segmented picker used to choose a workout section.
/// Designed for dark backgrounds with a modern capsule style.
struct WorkoutSectionPicker: View {
    @Binding var selection: WorkoutSection
    @Namespace private var animation

    var body: some View {
        HStack(spacing: 4) {
            ForEach(WorkoutSection.allCases, id: \.self) { section in
                segment(for: section)
            }
        }
    }

    @ViewBuilder
    private func segment(for section: WorkoutSection) -> some View {
        let isSelected = selection == section
        Button(action: { withAnimation(.easeInOut) { selection = section } }) {
            HStack(spacing: 4) {
                Image(systemName: iconName(for: section))
                Text(section.displayTitle)
            }
            .font(Theme.font.caption.bold())
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.spacing.small)
            .foregroundStyle(isSelected ? Color.white : Theme.color.textPrimary)
            .background(
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: Theme.radius.button)
                            .fill(Theme.color.accent)
                            .matchedGeometryEffect(id: "bg", in: animation)
                    } else {
                        RoundedRectangle(cornerRadius: Theme.radius.button)
                            .fill(Theme.color.backgroundSecondary.opacity(0.6))
                    }
                }
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(section.displayName)
    }

    private func iconName(for section: WorkoutSection) -> String {
        switch section {
        case .warmUp: return "figure.walk" // warm-up icon
        case .main: return "flame.fill" // main workout icon
        case .coolDown: return "figure.cooldown" // cool-down icon
        }
    }
}

#if DEBUG
struct WorkoutSectionPicker_Previews: PreviewProvider {
    @State static var selection: WorkoutSection = .main
    static var previews: some View {
        WorkoutSectionPicker(selection: $selection)
            .padding()
            .background(Color.black)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
#endif
