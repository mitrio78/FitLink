import Foundation

extension ExerciseMetricType {
    /// Sort order placing repetitions first, weight second, others afterward
    var sortIndex: Int {
        switch self {
        case .reps: return 0
        case .weight: return 1
        default: return 2
        }
    }
}
