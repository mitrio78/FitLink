import SwiftUI

/// Flat card representing either a single exercise or a grouped block
struct ExerciseBlockCard: View {
    let group: SetGroup?
    let exerciseInstances: [ExerciseInstance]
    var onEdit: () -> Void = {}
    var onSetTap: (ExerciseInstance, ExerciseSet.ID) -> Void = { _,_ in }
    var onAddSet: (ExerciseInstance) -> Void = { _ in }
    var isLocked: Bool = false
    var isFirstInGroup: Bool = true
    var isLastInGroup: Bool = true
    var isGrouped: Bool = false

    var body: some View {
        let innerSpacing = Theme.current.layoutMode == .compact ? Theme.current.spacing.compactInnerSpacing : Theme.spacing.small
        let outerPadding = Theme.current.layoutMode == .compact ? Theme.current.spacing.compactBlockPadding : Theme.spacing.medium
        VStack(alignment: .leading, spacing: innerSpacing) {
            if let group, group.type != .superset {
                Text(group.type.displayName)
                    .font(Theme.font.caption)
                    .foregroundColor(Theme.color.textSecondary)
            }

            Text(title)
                .font(Theme.current.layoutMode == .compact ? Theme.font.compactExerciseTitle : Theme.font.subheading)
                .lineLimit(2)
                .truncationMode(.tail)
            
            Divider()

            if let main = exerciseInstances.first {
                ApproachListView(
                    sets: main.approaches.map { approach in
                        var first = approach.sets.first ?? ExerciseSet(id: UUID(), metricValues: [:], notes: nil, drops: nil)
                        first.drops = Array(approach.sets.dropFirst())
                        return first
                    },
                    metrics: main.exercise.metrics,
                    onSetTap: { setId in
                        onSetTap(main, setId)
                    },
                    onAddTap: {
                        onAddSet(main)
                    },
                    isLocked: isLocked
                )
            }
        }
        .padding(.horizontal , outerPadding)
        .padding(.top, isGrouped && !isFirstInGroup ? 0 : outerPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isGrouped ? Theme.color.supersetSubcardBackground : Theme.color.backgroundSecondary)
        .clipShape(RoundedCornerShape(
            radius: Theme.radius.card,
            corners: cornersToRound
        ))
    }

    private var cornersToRound: UIRectCorner {
        guard isGrouped else { return .allCorners }
        var corners: UIRectCorner = []
        if isFirstInGroup { corners.formUnion([.topLeft, .topRight]) }
        if isLastInGroup { corners.formUnion([.bottomLeft, .bottomRight]) }
        return corners
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
    let set1 = ExerciseSet(id: UUID(), metricValues: [.weight: 50, .reps: 8], notes: nil, drops: nil)
    let set2 = ExerciseSet(id: UUID(), metricValues: [.weight: 50, .reps: 8], notes: nil, drops: nil)
    ExerciseBlockCard(
        group: .some(
            .init(id: UUID(),
            type: .pyramid,
            exerciseInstanceIds: []
                 )
        ),
        exerciseInstances: [
            .init(
                id: UUID(),
                exercise: .init(
                    id: UUID(),
                    name: "Подпрыгивания",
                    variations: ["Весело", "Задорно"],
                    muscleGroups: [.custom("Все")],
                    metrics: [
                        .init(
                            type: .weight,
                            isRequired: true
                        ),
                        .init(
                            type: .reps,
                            isRequired: true
                        )
                    ]
                ),
                approaches: [
                    .init(
                        sets: [
                            set1
                        ]
                    ),
                    .init(
                        sets: [
                            set2
                        ]
                    )
                ]
            )
        ]
        , onAddSet: { _ in }, isLocked: false)
}
