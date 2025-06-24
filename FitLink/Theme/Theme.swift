import SwiftUI

enum Theme {
    static let color = AppColors.self
    static let font = AppTypography.self
    static let spacing = AppSpacing.self
    static let radius = AppRadius.self
    static let shadow = AppShadows.self
    static let size = AppSize.self

    /// Flag controlling the compact UI mode.
    static var isCompactUIEnabled: Bool = true
}
