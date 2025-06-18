import SwiftUI

/// Reusable row for a workout exercise or set group
struct WorkoutExerciseRowView: View {
    let exercise: ExerciseInstance
    let group: SetGroup?
    let groupExercises: [ExerciseInstance]

    init(exercise: ExerciseInstance, group: SetGroup? = nil, groupExercises: [ExerciseInstance] = []) {
        self.exercise = exercise
        self.group = group
        self.groupExercises = groupExercises
    }

    var body: some View {
        Group {
            if let group {
                if group.type == .superset {
                    SupersetCell(group: group, exercises: groupExercises)
                } else {
                    ExerciseBlockCard(group: group, exerciseInstances: groupExercises)
                }
            } else {
                ExerciseBlockCard(group: nil, exerciseInstances: [exercise])
            }
        } //: Group
    }
}

@MainActor
final class WorkoutExerciseRowViewModel: ObservableObject {}

#Preview {
    if let session = MockData.complexMockSessions.first {
        WorkoutExerciseRowView(
            exercise: session.exerciseInstances.first!,
            group: session.setGroups?.first,
            groupExercises: session.setGroups?.first.map { grp in session.exerciseInstances.filter { grp.exerciseInstanceIds.contains($0.id) } } ?? []
        )
        .padding()
    }
}
