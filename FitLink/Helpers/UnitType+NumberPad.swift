import Foundation

extension UnitType {
    /// Returns a set of unit options appropriate for the current unit.
    var numberPadOptions: [UnitType] {
        switch self {
        case .kilogram, .pound:
            return [.kilogram, .pound]
        case .second, .minute:
            return [.second, .minute]
        case .meter, .kilometer:
            return [.meter, .kilometer]
        case .repetition:
            return [.repetition]
        case .calorie:
            return [.calorie]
        case .custom:
            return [self]
        }
    }
}

extension UnitType {
    /// Display label used in CustomNumberPadView for the current unit.
    var numberPadLabel: String? {
        if self == .repetition {
            return NSLocalizedString("CustomNumberPad.RepsLabel", comment: "× reps suffix")
        }
        let text = displayName
        return text.isEmpty ? nil : text
    }
}
