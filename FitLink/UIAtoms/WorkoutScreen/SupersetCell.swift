import SwiftUI

/// Expandable card displaying a superset with its approaches.
struct SupersetCell: View {
    let group: SetGroup
    let exercises: [ExerciseInstance]
    var onEdit: () -> Void = {}
    var onSetsEdit: (ExerciseInstance, Int) -> Void = { _, _ in }
    var initiallyExpanded: Bool = false

    @State private var isExpanded: Bool

    init(group: SetGroup,
         exercises: [ExerciseInstance],
         initiallyExpanded: Bool = false,
         onEdit: @escaping () -> Void = {},
         onSetsEdit: @escaping (ExerciseInstance, Int) -> Void = { _, _ in }) {
        self.group = group
        self.exercises = exercises
        self.onEdit = onEdit
        self.onSetsEdit = onSetsEdit
        self.initiallyExpanded = initiallyExpanded
        _isExpanded = State(initialValue: initiallyExpanded)
    }

    private var approaches: [[(exercise: ExerciseInstance, approach: Approach?)]] {
        let maxCount = exercises.map { $0.approaches.count }.max() ?? 0
        return (0..<maxCount).map { index in
            exercises.map { ($0, $0.approaches[safe: index]) }
        }
    }

    private var title: String {
        exercises.map { $0.exercise.name }.joined(separator: "\n+ ")
    }

    private var summary: String? {
        let count = exercises.map { $0.approaches.count }.max() ?? 0
        guard count > 1 else { return nil }
        return String(format: NSLocalizedString("WorkoutSetGroup.RepsMultiplier", comment: "× %d"), count)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small) {
            header
            if isExpanded {
                VStack(alignment: .leading, spacing: Theme.spacing.small * 1.5) {
                    ForEach(Array(approaches.enumerated()), id: \.offset) { idx, data in
                        SupersetApproachView(index: idx + 1, items: data) { ex in
                            onSetsEdit(ex, idx)
                        }
                            .padding(Theme.spacing.small)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Theme.color.supersetSubcardBackground)
                            )
                            .onTapGesture { onEdit() }
                    }
                }
                .padding(.top, Theme.spacing.small)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut, value: isExpanded)
        .padding(Theme.spacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.color.backgroundSecondary)
        .cornerRadius(Theme.radius.card)
    }

    private var header: some View {
        Button(action: { isExpanded.toggle() }) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: Theme.spacing.small / 2) {
                    Text(group.type.displayName)
                        .font(Theme.font.caption)
                        .foregroundColor(Theme.color.textSecondary)
                    Text(title)
                        .font(Theme.font.subheading)
                        .lineLimit(2)
                        .truncationMode(.tail)
                    if !isExpanded, let summary {
                        Text(summary)
                            .font(Theme.font.metadata)
                            .foregroundColor(Theme.color.textSecondary)
                    }
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .foregroundColor(.secondary)
            }
        }
        .animation(.easeInOut, value: isExpanded)
        .buttonStyle(.plain)
    }
}
