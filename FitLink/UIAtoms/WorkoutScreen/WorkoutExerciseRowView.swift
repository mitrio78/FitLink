import SwiftUI

struct WorkoutExerciseRowView: View {
    let exercise: ExerciseInstance
    let group: SetGroup?
    var groupExercises: [ExerciseInstance] = []
    var onEdit: () -> Void
    var onDelete: () -> Void
    var onMetricEdit: (ExerciseInstance, ExerciseSet.ID, ExerciseMetric) -> Void
    var initiallyExpanded: Bool = false

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
                SupersetCell(group: group,
                             exercises: groupExercises,
                             initiallyExpanded: initiallyExpanded,
                             onEdit: onEdit,
                             onMetricTap: { ex, setId, metric in
                                 onMetricEdit(ex, setId, metric)
                             })
            } else {
                ExerciseBlockCard(group: group, exerciseInstances: groupExercises, onEdit: onEdit, onMetricTap: { ex, setId, metric in
                    onMetricEdit(ex, setId, metric)
                })
            }
        } else {
            ExerciseBlockCard(group: nil, exerciseInstances: [exercise], onEdit: onEdit, onMetricTap: { _, setId, metric in
                onMetricEdit(exercise, setId, metric)
            })
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
                                  onMetricEdit: { _,_,_ in },
                                  initiallyExpanded: false)
        .padding()
}
