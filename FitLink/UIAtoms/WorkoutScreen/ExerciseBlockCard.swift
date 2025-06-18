import SwiftUI

/// Flat card representing either a single exercise or a grouped block
struct ExerciseBlockCard: View {
    let group: SetGroup?
    let exerciseInstances: [ExerciseInstance]
    var onEdit: () -> Void = {}

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

            if let main = exerciseInstances.first {
                ApproachListView(
                    sets: main.approaches.map { approach in
                        var first = approach.sets.first ?? ExerciseSet(id: UUID(), metricValues: [:], notes: nil, drops: nil)
                        first.drops = Array(approach.sets.dropFirst())
                        return first
                    },
                    metrics: main.exercise.metrics,
                    onTap: onEdit
                )
            }
        }
        .padding(Theme.spacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.color.backgroundSecondary)
        .cornerRadius(Theme.radius.card)
    }

    private var title: String {
        let names = exerciseInstances.map { $0.exercise.name }
        if let group, group.type == .superset {
            return names.joined(separator: "\n+ ")
        }
        return names.joined(separator: " \u{2022} ")
    }
}

#Preview {
    ExerciseBlockCard(group: .some(.init(id: UUID(), type: .pyramid, exerciseInstanceIds: [])), exerciseInstances: [.init(id: UUID(), exercise: .init(id: UUID(), name: "Подпрыгивания", variations: ["Весело", "Задорно"], muscleGroups: [.custom("Все")], metrics: [.init(type: .reps, isRequired: true)]), approaches: [.init(sets: [.init(id: UUID(), metricValues: [.time: 20])])])])
}
