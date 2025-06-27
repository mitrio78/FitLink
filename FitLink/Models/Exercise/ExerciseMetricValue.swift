import Foundation

enum ExerciseMetricValue: Codable, Equatable, Hashable {
    case int(Int)
    case double(Double)

    var doubleValue: Double {
        switch self {
        case .int(let value): return Double(value)
        case .double(let value): return value
        }
    }

    var formatted: String {
        switch self {
        case .int(let value):
            return "\(value)"
        case .double(let value):
            return value == floor(value) ? "\(Int(value))" : String(format: "%.1f", value)
        }
    }

    var intValue: Int? {
        if case let .int(value) = self {
            return value
        }
        return nil
    }
}
