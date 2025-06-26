import Foundation
import SwiftUI

@MainActor
final class AppSettings: ObservableObject {
    static let shared = AppSettings()

    /// Indicates if compact UI layout should be used across the app.
    @Published var isCompactModeEnabled: Bool = false {
        didSet {
            Theme.layoutMode = isCompactModeEnabled ? .compact : .regular
        }
    }

    private init() {
        Theme.layoutMode = isCompactModeEnabled ? .compact : .regular
    }
}
