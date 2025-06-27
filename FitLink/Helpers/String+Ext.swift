import Foundation

extension String {
    /// Removes leading zeros except before decimal point
    func trimLeadingZeros() -> String {
        var result = self
        while result.hasPrefix("0") && result.count > 1 && !result.hasPrefix("0.") {
            result.removeFirst()
        }
        return result
    }
}
