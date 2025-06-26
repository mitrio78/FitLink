import SwiftUI

enum AppSpacing {
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let extraLarge: CGFloat = 32
    static let sheetTopPadding: CGFloat = 4
    static let sheetBottomPadding: CGFloat = 4

    /// Standard horizontal padding for lists and views.
    static let horizontal: CGFloat = 16

    /// Reduced horizontal padding when compact UI mode is enabled.
    static let compactHorizontal: CGFloat = 12

    /// Padding around workout blocks when compact UI mode is enabled.
    static let compactBlockPadding: CGFloat = 8

    /// Base spacing between inner UI elements in compact mode.
    static let compactInnerSpacing: CGFloat = 4

    /// Spacing used between metric items and blocks in compact mode.
    static let compactMetricSpacing: CGFloat = 2

    /// Spacing between set rows when compact UI is active.
    static let compactSetRowSpacing: CGFloat = 4

    /// Horizontal padding inside metric pills when compact UI is active.
    static let compactMetricHorizontalPadding: CGFloat = 6

    /// Vertical padding inside metric pills when compact UI is active.
    static let compactMetricVerticalPadding: CGFloat = 4

    /// Vertical spacing between metric lines inside approach cards.
    static let metricLineSpacing: CGFloat = 2
}
