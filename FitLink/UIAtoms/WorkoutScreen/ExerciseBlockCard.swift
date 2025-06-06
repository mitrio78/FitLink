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
            return "\(setCount) sets"
        }
        var parts: [String] = ["\(setCount) sets"]
        if let approach = first.approaches.first {
            for metric in first.exercise.metrics {
                if let value = approach.set.metricValues[metric.type] {
                    parts.append(ExerciseMetric.formattedMetric(value, metric: metric))
                }
            }
        }
        return parts.joined(separator: " \u{00b7} ")
    }

    private var setCount: Int {
        if let group {
            return exerciseInstances.map { $0.approaches.count }.max() ?? 0
        }
        return exerciseInstances.first?.approaches.count ?? 0
    }
}
