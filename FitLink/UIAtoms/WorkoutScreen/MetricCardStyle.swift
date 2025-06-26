import SwiftUI

/// Shared style for metric cards and the add-set button.
struct MetricCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        let horizontalPadding = Theme.current.layoutMode == .compact ? Theme.current.spacing.compactMetricHorizontalPadding : Theme.spacing.small
        let verticalPadding = Theme.current.layoutMode == .compact ? Theme.current.spacing.compactMetricVerticalPadding : Theme.spacing.small
        let corner = Theme.current.layoutMode == .compact ? Theme.current.radius.compactSetCell : Theme.radius.card
        content
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .background(Theme.color.textSecondary.opacity(0.05))
            .cornerRadius(corner)
    }
}

extension View {
    /// Applies standard styling for approach metric cards.
    func metricCardStyle() -> some View {
        modifier(MetricCardStyle())
    }
}
