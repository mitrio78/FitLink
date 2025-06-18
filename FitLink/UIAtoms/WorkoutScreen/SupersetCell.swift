import SwiftUI

/// Expandable card displaying a superset with its approaches.
struct SupersetCell: View {
    let group: SetGroup
    let exercises: [ExerciseInstance]
    var onEdit: () -> Void = {}
    var onSetsEdit: (ExerciseInstance) -> Void = { _ in }

    @State private var isExpanded = false

    private var title: String {
        exercises.map { $0.exercise.name }.joined(separator: "\n+ ")
    }

    private var summary: String? {
        let count = exercises.map { $0.approaches.count }.min() ?? 0
        guard count > 1 else { return nil }
        return String(format: NSLocalizedString("WorkoutSetGroup.RepsMultiplier", comment: "× %d"), count)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small) {
            header
            if isExpanded {
                VStack(alignment: .leading, spacing: Theme.spacing.small * 1.5) {
                    ForEach(exercises) { ex in
                        VStack(alignment: .leading, spacing: Theme.spacing.small / 2) {
                            Text(ex.exercise.name)
                                .font(Theme.font.body.bold())
                            ApproachListView(
                                sets: ex.approaches.map { approach in
                                    var first = approach.sets.first ?? ExerciseSet(id: UUID(), metricValues: [:], notes: nil, drops: nil)
                                    first.drops = Array(approach.sets.dropFirst())
                                    return first
                                },
                                metrics: ex.exercise.metrics,
                                onTap: { onSetsEdit(ex) }
                            )
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
