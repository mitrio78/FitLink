import SwiftUI

struct WorkoutExerciseRowView: View {
    let exercise: ExerciseInstance
    let group: SetGroup?
    var groupExercises: [ExerciseInstance] = []
    var onHistory: () -> Void = {}
    var onEdit: () -> Void
    var onDuplicate: () -> Void = {}
    var onDetails: () -> Void = {}
    var onDelete: () -> Void
    var onSetEdit: (ExerciseInstance, ExerciseSet.ID) -> Void
    var onAddSet: (ExerciseInstance) -> Void = { _ in }
    var isLocked: Bool = false
    var initiallyExpanded: Bool = false
    var isFirstInGroup: Bool = true
    var isLastInGroup: Bool = true
    var isGrouped: Bool = false

    @State private var showActions: Bool = false

    var body: some View {
        ZStack {
            content
        } //: ZStack
        .contentShape(Rectangle())
        .swipeActions(allowsFullSwipe: false) {
            Button(role: .destructive, action: onDelete) {
                Label(NSLocalizedString("Common.Delete", comment: "Delete"), systemImage: "trash")
                    .labelStyle(.iconOnly)
            }
        }
        .confirmationDialog("", isPresented: $showActions) {
            Button(NSLocalizedString("WorkoutExercise.Actions.History", comment: "History")) { onHistory() }
            Button(NSLocalizedString("WorkoutExercise.Actions.Edit", comment: "Edit")) { onEdit() }
            Button(NSLocalizedString("WorkoutExercise.Actions.Duplicate", comment: "Duplicate")) { onDuplicate() }
            Button(NSLocalizedString("WorkoutExercise.Actions.Details", comment: "Details")) { onDetails() }
            Button(NSLocalizedString("Common.Cancel", comment: "Cancel"), role: .cancel) { }
        }
    }

    @ViewBuilder
    private var content: some View {
        if let group, !groupExercises.isEmpty, group.type != .superset {
            ExerciseBlockCard(group: group,
                              exerciseInstances: groupExercises,
                              onSetTap: { ex, setId in
                                  onSetEdit(ex, setId)
                              },
                              onAddSet: { ex in
                                  onAddSet(ex)
                              },
                              onMenuTap: { showActions = true },
                              isLocked: isLocked)
        } else {
            ExerciseBlockCard(group: group?.type == .superset ? group : nil,
                              exerciseInstances: [exercise],
                              onSetTap: { _, setId in
                                  onSetEdit(exercise, setId)
                              },
                              onAddSet: { _ in
                                  onAddSet(exercise)
                              },
                              onMenuTap: { showActions = true },
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
                                  onHistory: {},
                                  onEdit: {},
                                  onDuplicate: {},
                                  onDetails: {},
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
