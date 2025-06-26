import SwiftUI

enum Theme {
    enum LayoutMode {
        case regular
        case compact
    }

    /// Controls which layout mode is active. In the future this should come
    /// from user settings.
    static var layoutMode: LayoutMode = .compact

    static let color = AppColors.self
    static let font = AppTypography.self
    static let spacing = AppSpacing.self
    static let radius = AppRadius.self
    static let shadow = AppShadows.self
    static let size = AppSize.self

    /// Convenience flag mirroring the current layout mode.
    static var isCompactUIEnabled: Bool { layoutMode == .compact }

    struct Proxy {
        var spacing: AppSpacing.Type { AppSpacing.self }
        var font: AppTypography.Type { AppTypography.self }
        var radius: AppRadius.Type { AppRadius.self }
        var layoutMode: LayoutMode { Theme.layoutMode }
    }

    /// Accessor used by views to read style tokens with the current layout mode
    /// semantics.
    static var current: Proxy { Proxy() }
}
