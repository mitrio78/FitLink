import Foundation

extension Double {
    /// Returns a trimmed string without trailing zeros, suitable for number pad display.
    func numberPadString() -> String {
        if self == floor(self) {
            return String(Int(self))
        } else {
            var str = String(format: "%.2f", self)
            while str.contains(".") && str.last == "0" { str.removeLast() }
            if str.last == "." { str.removeLast() }
            return str
        }
    }
}
