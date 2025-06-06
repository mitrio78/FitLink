import Foundation

/// Sections of a workout session
enum WorkoutSection: String, Codable, CaseIterable, Hashable {
    case warmUp
    case main
    case coolDown

    var title: String {
        switch self {
        case .warmUp:
            return NSLocalizedString("WorkoutSection.WarmUp", comment: "Warm-up")
        case .main:
            return NSLocalizedString("WorkoutSection.Main", comment: "Main Set")
        case .coolDown:
            return NSLocalizedString("WorkoutSection.CoolDown", comment: "Cool-down")
        }
    }
}
