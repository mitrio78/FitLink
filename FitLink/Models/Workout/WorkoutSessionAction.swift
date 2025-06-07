import Foundation

/// Actions available on the Workout screen
enum WorkoutSessionAction: String, CaseIterable, Hashable {
    case addExercise = "WorkoutSession.AddExercise"
    case addGroupedExercise = "WorkoutSession.AddGroupedExercise"
    case addBlock = "WorkoutSession.AddBlock"
    case clonePrevious = "WorkoutSession.ClonePrevious"
    case save = "WorkoutSession.Save"

    /// Localized label for button titles
    var label: String {
        NSLocalizedString(rawValue, comment: "")
    }

    /// Title used for action buttons
    var buttonTitle: String { label }
}
