import SwiftUI

struct MuscleGroupBadge: View {
    let group: MuscleGroup
    var isMain: Bool = false

    var body: some View {
        Text(group.displayName)
            .font(Theme.font.caption)
            .padding(.horizontal, Theme.spacing.small)
            .padding(.vertical, Theme.spacing.extraSmall)
            .background(isMain ? group.color : group.color.opacity(0.18))
            .foregroundColor(isMain ? .white : group.color)
            .clipShape(Capsule())
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 8) {
        MuscleGroupBadge(group: .biceps)
        MuscleGroupBadge(group: .chest, isMain: true)
    } //: VStack
    .padding()
}
#endif
