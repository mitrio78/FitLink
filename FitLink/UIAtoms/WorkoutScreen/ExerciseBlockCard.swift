import SwiftUI

/// Flat card representing either a single exercise or a grouped block
struct ExerciseBlockCard: View {
    let group: SetGroup?
    let exerciseInstances: [ExerciseInstance]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small) {
            if let group {
                Text(group.type.displayName)
                    .font(Theme.font.caption)
                    .foregroundColor(Theme.color.textSecondary)
            }

            Text(title)
                .font(Theme.font.subheading)
                .lineLimit(2)
                .truncationMode(.tail)

            setsSubtitle
                .accessibilityLabel(accessibilityDescription)
        }
        .padding(Theme.spacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.color.backgroundSecondary)
        .cornerRadius(Theme.radius.card)
    }

    private var title: String {
        let names = exerciseInstances.map { $0.exercise.name }
        if let group, group.type == .superset {
            return names.joined(separator: " + ")
        }
        return names.joined(separator: " \u{2022} ")
    }

    private struct DisplaySet: Identifiable {
        let id = UUID()
        let weight: String
        let reps: String
    }

    private var setsSubtitle: some View {
        HStack(spacing: Theme.spacing.medium) {
            ForEach(displaySets.prefix(4)) { item in
                VStack(alignment: .leading, spacing: 0) {
                    Text(item.weight)
                        .font(Theme.font.body.bold())
                    Text(item.reps)
                        .font(Theme.font.metadata)
                        .foregroundColor(Theme.color.textSecondary)
                }
            }
            if displaySets.count > 4 {
                VStack(alignment: .leading, spacing: 0) {
                    Text("…")
                        .font(Theme.font.metadata)
                        .foregroundColor(Theme.color.textSecondary)
                    Text(" ")
                        .font(Theme.font.metadata)
                        .foregroundColor(Theme.color.textSecondary)
                }
            }
        }
    }

    private var displaySets: [DisplaySet] {
        guard let first = exerciseInstances.first else { return [] }
        let metrics = first.exercise.metrics
        let weightMetric = metrics.first { $0.type == .weight }
        let repMetric = metrics.first { $0.type == .reps || $0.type == .time }

        return first.approaches.map { approach in
            var weightText = ""
            if let weightMetric,
               let value = approach.set.metricValues[weightMetric.type] {
                var weights: [String] = [ExerciseMetric.formattedMetric(value, metric: weightMetric)]
                if let drops = approach.drops {
                    for drop in drops {
                        if let dropVal = drop.metricValues[weightMetric.type] {
                            weights.append(ExerciseMetric.formattedMetric(dropVal, metric: weightMetric))
                        }
                    }
                }
                weightText = weights.joined(separator: "\u{2192}")
            }

            var repText = ""
            if let repMetric,
               let repVal = approach.set.metricValues[repMetric.type] {
                if repMetric.type == .reps {
                    repText = "x\(Int(repVal))"
                } else {
                    repText = ExerciseMetric.formattedMetric(repVal, metric: repMetric)
                }
            }

            return DisplaySet(weight: weightText, reps: repText)
        }
    }

    private var accessibilityDescription: String {
        let ordinals = ["Первый", "Второй", "Третий", "Четвёртый"]
        var parts: [String] = []
        for (idx, set) in displaySets.prefix(4).enumerated() {
            let ord = idx < ordinals.count ? ordinals[idx] : "\(idx + 1)-й"
            var text = "\(ord) подход: "
            if !set.weight.isEmpty { text += "\(set.weight), " }
            text += "\(set.reps)."
            parts.append(text)
        }
        if displaySets.count > 4 { parts.append("...") }
        return parts.joined(separator: " ")
    }

}
