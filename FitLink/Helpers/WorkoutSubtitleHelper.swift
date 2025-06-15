import Foundation

func makeSubtitle(from sets: [ExerciseSet]) -> String {
    let displaySets = sets.prefix(4)
    let setStrings = displaySets.map { setDescription(for: $0) }
    var result = setStrings.joined(separator: " ")
    if sets.count > 4 {
        result += " \u{2026}"
    }
    return result
}

private func setDescription(for set: ExerciseSet) -> String {
    var steps: [ExerciseSet] = [set]
    if let drops = set.drops, !drops.isEmpty {
        steps.append(contentsOf: drops)
    }
    let stepStrings = steps.map { step in
        var weightString: String?
        if let w = step.metricValues[.weight] {
            weightString = "\(formatNumber(w))kg"
        }
        var mainString: String = ""
        if let reps = step.metricValues[.reps] {
            if let weight = weightString {
                mainString = "\(weight)\u{00d7}\(Int(reps))"
            } else {
                mainString = "\(Int(reps))reps"
            }
        } else if let time = step.metricValues[.time] {
            if let weight = weightString {
                mainString = "\(weight)\u{00d7}\(timeString(from: time))"
            } else {
                mainString = timeString(from: time)
            }
        } else if let weight = weightString {
            mainString = weight
        }
        return mainString
    }
    return stepStrings.joined(separator: "\u{2192}")
}

private func formatNumber(_ value: Double) -> String {
    if value == floor(value) {
        return String(Int(value))
    }
    return String(format: "%.1f", value)
}

private func timeString(from value: Double) -> String {
    let total = Int(value)
    if total >= 60 {
        let minutes = total / 60
        let seconds = total % 60
        if seconds > 0 {
            return "\(minutes)min\(seconds)sec"
        } else {
            return "\(minutes)min"
        }
    } else {
        return "\(total)sec"
    }
}

func makeSubtitleAccessibility(from sets: [ExerciseSet]) -> String {
    let displaySets = sets.prefix(4)
    var resultParts: [String] = []
    for (idx, set) in displaySets.enumerated() {
        let desc = accessibilityDescription(for: set)
        resultParts.append("Set \(idx + 1): \(desc)")
    }
    var result = resultParts.joined(separator: "; ")
    if sets.count > 4 {
        result += "; ..."
    }
    return result
}

private func accessibilityDescription(for set: ExerciseSet) -> String {
    var steps: [ExerciseSet] = [set]
    if let drops = set.drops, !drops.isEmpty {
        steps.append(contentsOf: drops)
    }
    let stepStrings = steps.map { step -> String in
        var parts: [String] = []
        if let weight = step.metricValues[.weight] {
            parts.append("\(formatNumber(weight)) kilograms")
        }
        if let reps = step.metricValues[.reps] {
            parts.append("\(Int(reps)) reps")
        } else if let time = step.metricValues[.time] {
            parts.append(accessibleTimeString(from: time))
        }
        return parts.joined(separator: " ")
    }
    return stepStrings.joined(separator: " then ")
}

private func accessibleTimeString(from value: Double) -> String {
    let total = Int(value)
    if total >= 60 {
        let minutes = total / 60
        let seconds = total % 60
        var result = "\(minutes) minute"
        if minutes != 1 { result += "s" }
        if seconds > 0 {
            result += " \(seconds) second"
            if seconds != 1 { result += "s" }
        }
        return result
    } else {
        return "\(total) second" + (total == 1 ? "" : "s")
    }
}
