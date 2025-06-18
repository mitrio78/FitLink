import SwiftUI

struct WorkoutExerciseRowView: View {
    let exercise: ExerciseInstance
    let group: SetGroup?
    var groupExercises: [ExerciseInstance] = []
    var onEdit: () -> Void
    var onDelete: () -> Void

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
        if let group, !groupExercises.isEmpty {
            if group.type == .superset {
                SupersetCell(group: group, exercises: groupExercises)
            } else {
                ExerciseBlockCard(group: group, exerciseInstances: groupExercises)
            }
        } else {
            ExerciseBlockCard(group: nil, exerciseInstances: [exercise])
        }
    }
}

#Preview {
    let session = MockData.complexMockSessions.first!
    let exercise = session.exerciseInstances.first!
    return WorkoutExerciseRowView(exercise: exercise, group: nil, onEdit: {}, onDelete: {})
        .padding()
}
