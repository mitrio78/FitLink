import SwiftUI

struct WorkoutExerciseRowView: View {
    let exercise: ExerciseInstance
    let group: SetGroup?
    var groupExercises: [ExerciseInstance] = []
    var onEdit: () -> Void
    var onDelete: () -> Void
    var onSetEdit: (ExerciseInstance, ExerciseSet.ID) -> Void
    var onAddSet: (ExerciseInstance) -> Void = { _ in }
    var isLocked: Bool = false
    var initiallyExpanded: Bool = false
    var isFirstInGroup: Bool = true
    var isLastInGroup: Bool = true
    var isGrouped: Bool = false

    var body: some View {
        ZStack {
            content
        } //: ZStack
        .contentShape(Rectangle())
        .swipeActions(allowsFullSwipe: false) {
            Button(action: onEdit) {
                Label(NSLocalizedString("Common.Edit", comment: "Edit"), systemImage: "gearshape")
                    .labelStyle(.iconOnly)
            }
            Button(role: .destructive, action: onDelete) {
                Label(NSLocalizedString("Common.Delete", comment: "Delete"), systemImage: "trash")
                    .labelStyle(.iconOnly)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if let group, !groupExercises.isEmpty, group.type != .superset {
            ExerciseBlockCard(group: group,
                              exerciseInstances: groupExercises,
                              onEdit: onEdit,
                              onSetTap: { ex, setId in
                                  onSetEdit(ex, setId)
                              },
                              onAddSet: { ex in
                                  onAddSet(ex)
                              },
                              isLocked: isLocked)
        } else {
            ExerciseBlockCard(group: group?.type == .superset ? group : nil,
                              exerciseInstances: [exercise],
                              onEdit: onEdit,
                              onSetTap: { _, setId in
                                  onSetEdit(exercise, setId)
                              },
                              onAddSet: { _ in
                                  onAddSet(exercise)
                              },
                              isLocked: isLocked,
                              isFirstInGroup: isFirstInGroup,
                              isLastInGroup: isLastInGroup,
                              isGrouped: isGrouped)
        }
    }
}

#Preview {
    let session = MockData.complexMockSessions.first!
    let exercise = session.exerciseInstances.first!
    return WorkoutExerciseRowView(exercise: exercise,
                                  group: nil,
                                  onEdit: {},
                                  onDelete: {},
                                  onSetEdit: { _,_ in },
                                  onAddSet: { _ in },
                                  isLocked: false,
                                  initiallyExpanded: false,
                                  isFirstInGroup: true,
                                  isLastInGroup: true,
                                  isGrouped: false)
        .padding()
}
