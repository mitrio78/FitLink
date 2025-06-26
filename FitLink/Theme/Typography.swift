import SwiftUI

enum AppTypography {
    static let titleLarge = Font.system(size: 28, weight: .bold)
    static let titleMedium = Font.system(size: 22, weight: .semibold)
    static let titleSmall = Font.system(size: 18, weight: .semibold)
    static let subheading = Font.system(size: 16, weight: .medium)
    static let body = Font.system(size: 15, weight: .regular)
    static let caption = Font.system(size: 13, weight: .regular)
    static let metadata = Font.system(size: 12, weight: .light)
    static let metrics1 = Font.system(size: 16, weight: .bold)
    static let metrics2 = Font.system(size: 16, weight: .semibold)

    /// Exercise title font for compact mode.
    static let compactExerciseTitle = Font.system(size: 14, weight: .medium)

    /// Metric value font used in compact mode.
    static let compactMetricValue = Font.system(size: 14, weight: .semibold)

    /// Metric unit font used in compact mode.
    static let compactMetricUnit = Font.system(size: 12, weight: .regular)
}
