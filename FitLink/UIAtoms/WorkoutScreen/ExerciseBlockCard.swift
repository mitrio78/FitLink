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

            if group == nil, let instance = exerciseInstances.first {
                let sets = instance.approaches.map { $0.set }
                Text(makeSubtitle(from: sets))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .accessibilityLabel(makeSubtitleAccessibility(from: sets))
            }

            Text(summary)
                .font(Theme.font.metadata)
                .foregroundColor(Theme.color.textSecondary)
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

    private var summary: String {
        guard let first = exerciseInstances.first else {
            return "\(setCount) \(setsText)"
        }
        var parts: [String] = ["\(setCount) \(setsText)"]
        if let approach = first.approaches.first {
            for metric in first.exercise.metrics {
                if let value = approach.set.metricValues[metric.type] {
                    parts.append(ExerciseMetric.formattedMetric(value, metric: metric))
                }
            }
        }
        return parts.joined(separator: " \u{00b7} ")
    }

    private var setsText: String {
        let mod100 = setCount % 100
        if mod100 >= 11 && mod100 <= 14 { return "подходов" }
        switch setCount % 10 {
        case 1: return "подход"
        case 2,3,4: return "подхода"
        default: return "подходов"
        }
    }

    private var setCount: Int {
        if let group {
            return exerciseInstances.map { $0.approaches.count }.max() ?? 0
        }
        return exerciseInstances.first?.approaches.count ?? 0
    }
}
