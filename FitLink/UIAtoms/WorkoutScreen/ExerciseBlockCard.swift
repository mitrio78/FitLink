import SwiftUI

/// Flat card representing either a single exercise or a grouped block
struct ExerciseBlockCard: View {
    let group: SetGroup?
    let exerciseInstances: [ExerciseInstance]
    var onEdit: () -> Void = {}
    var onSetTap: (ExerciseInstance, ExerciseSet.ID) -> Void = { _,_ in }
    var onAddSet: (ExerciseInstance) -> Void = { _ in }
    var onMenuTap: () -> Void = {}
    var isLocked: Bool = false
    var isFirstInGroup: Bool = true
    var isLastInGroup: Bool = true
    var isGrouped: Bool = false

    var body: some View {
        let innerSpacing = Theme.current.layoutMode == .compact ? Theme.current.spacing.compactInnerSpacing : Theme.spacing.small
        let outerPadding = Theme.current.layoutMode == .compact ? Theme.current.spacing.compactBlockPadding : Theme.spacing.medium
        VStack(alignment: .leading, spacing: innerSpacing) {
            if let group, shouldShowGroupTitle {
                Text(group.type.displayName)
                    .font(Theme.font.caption)
                    .foregroundColor(Theme.color.textSecondary)
            }

            HStack(alignment: .top) {
                Text(title)
                    .font(Theme.current.layoutMode == .compact ? Theme.font.compactExerciseTitle : Theme.font.subheading)
                    .lineLimit(2)
                    .truncationMode(.tail)
                Spacer(minLength: Theme.spacing.small)
                Button(action: onMenuTap) {
                    Image(systemName: "line.3.horizontal")
                        .padding(8)
                        .background(Theme.color.backgroundSecondary.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.radius.button))
                }
                .foregroundColor(Theme.color.textSecondary)
                .buttonStyle(.plain)
            } //: HStack
            .contentShape(Rectangle())
            .onTapGesture { onMenuTap() }

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
        .padding(.horizontal, outerPadding)
        .padding(.top, isGrouped && !isFirstInGroup ? 0 : outerPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.color.backgroundSecondary)
        .clipShape(RoundedCornerShape(
            radius: Theme.radius.card,
            corners: cornersToRound
        ))
    }

    private var shouldShowGroupTitle: Bool {
        guard let group = group else { return false }
        switch group.type {
        case .superset:
            return isFirstInGroup
        default:
            return true
        }
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
    let set1 = ExerciseSet(id: UUID(), metricValues: [.weight: .double(50), .reps: .int(8)], notes: nil, drops: nil)
    let set2 = ExerciseSet(id: UUID(), metricValues: [.weight: .double(50), .reps: .int(8)], notes: nil, drops: nil)
    ExerciseBlockCard(
        group: .some(
            .init(id: UUID(),
            type: .superset,
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
        , onAddSet: { _ in }, onMenuTap: {}, isLocked: false)
}
