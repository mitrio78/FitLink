import SwiftUI

/// Reusable row for a workout exercise or set group
struct WorkoutExerciseRowView: View {
    let exercise: ExerciseInstance
    let group: SetGroup?
    let groupExercises: [ExerciseInstance]
    let onDelete: () -> Void

    @State private var isExpanded = false

    var body: some View {
        Group {
            if let group, group.type == .superset {
                supersetRow
            } else {
                simpleRow
            }
        } //: Group
    }

    private var supersetRow: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: Theme.spacing.small / 2) {
                        Text(group?.type.displayName ?? "")
                            .font(Theme.font.caption)
                            .foregroundColor(Theme.color.textSecondary)
                        Text(supersetTitle)
                            .font(Theme.font.subheading)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        if !isExpanded, let summary = supersetSummary {
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
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: Theme.spacing.small * 1.5) {
                    ForEach(Array(supersetApproaches.enumerated()), id: \.offset) { idx, data in
                        SupersetApproachView(index: idx + 1, items: data)
                            .padding(Theme.spacing.small)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Theme.color.supersetSubcardBackground)
                            )
                    }
                }
                .padding(.top, Theme.spacing.small)
            }
        }
        .padding(Theme.spacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.color.backgroundSecondary)
        .cornerRadius(Theme.radius.card)
        .contentShape(Rectangle())
        .swipeActions {
            deleteButton
        }
    }

    private var simpleRow: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small) {
            if let group, group.type != .superset {
                Text(group.type.displayName)
                    .font(Theme.font.caption)
                    .foregroundColor(Theme.color.textSecondary)
            }

            Text(simpleTitle)
                .font(Theme.font.subheading)
                .lineLimit(2)
                .truncationMode(.tail)

            let main = groupExercises.first ?? exercise
            ExerciseSetMetricsView(
                sets: main.approaches.map { approach in
                    var first = approach.sets.first ?? ExerciseSet(id: UUID(), metricValues: [:], notes: nil, drops: nil)
                    first.drops = Array(approach.sets.dropFirst())
                    return first
                },
                metrics: main.exercise.metrics
            )
        }
        .padding(Theme.spacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.color.backgroundSecondary)
        .cornerRadius(Theme.radius.card)
        .contentShape(Rectangle())
        .swipeActions {
            deleteButton
        }
    }

    private var deleteButton: some View {
        Button(role: .destructive, action: onDelete) {
            Label(NSLocalizedString("Common.Delete", comment: "Удалить"), systemImage: "trash")
        }
    }

    private var supersetTitle: String {
        groupExercises.map { $0.exercise.name }.joined(separator: "\n+ ")
    }

    private var supersetSummary: String? {
        let count = supersetApproaches.count
        guard count > 1 else { return nil }
        return String(format: NSLocalizedString("WorkoutSetGroup.RepsMultiplier", comment: "× %d"), count)
    }

    private var supersetApproaches: [[(exercise: ExerciseInstance, approach: Approach)]] {
        let minCount = groupExercises.map { $0.approaches.count }.min() ?? 0
        return (0..<minCount).map { index in
            groupExercises.map { ($0, $0.approaches[index]) }
        }
    }

    private var simpleTitle: String {
        let names = (groupExercises.isEmpty ? [exercise] : groupExercises).map { $0.exercise.name }
        return names.joined(separator: " \u{2022} ")
    }
}

@MainActor
final class WorkoutExerciseRowViewModel: ObservableObject {}

#Preview {
    if let session = MockData.complexMockSessions.first,
       let first = session.exerciseInstances.first {
        WorkoutExerciseRowView(
            exercise: first,
            group: session.setGroups?.first,
            groupExercises: session.setGroups?.first.map { grp in
                session.exerciseInstances.filter { grp.exerciseInstanceIds.contains($0.id) }
            } ?? [],
            onDelete: {}
        )
        .padding()
    }
}
