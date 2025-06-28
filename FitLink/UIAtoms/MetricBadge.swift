import SwiftUI

struct MetricBadge: View {
    let metric: ExerciseMetric

    var body: some View {
        HStack(spacing: 4) {
            if let icon = metric.iconName {
                Image(systemName: icon)
            }
            Text(metric.displayName)
        } //: HStack
        .font(Theme.font.caption)
        .padding(.horizontal, Theme.spacing.small)
        .padding(.vertical, Theme.spacing.extraSmall)
        .background(Theme.color.badgeBackground)
        .foregroundColor(Theme.color.textPrimary)
        .clipShape(Capsule())
    }
}

#if DEBUG
#Preview {
    HStack(spacing: 8) {
        MetricBadge(metric: ExerciseMetric(type: .reps, unit: .repetition, isRequired: true))
        MetricBadge(metric: ExerciseMetric(type: .weight, unit: .kilogram, isRequired: false))
    } //: HStack
    .padding()
    .previewLayout(.sizeThatFits)
}
#endif
