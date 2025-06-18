import SwiftUI

struct WorkoutExerciseRowViewModel {
    let group: SetGroup?
    let exercises: [ExerciseInstance]
}

struct WorkoutExerciseRowView: View {
    let viewModel: WorkoutExerciseRowViewModel

    var body: some View {
        ExerciseBlockCard(
            group: viewModel.group,
            exerciseInstances: viewModel.exercises
        )
    }
}

extension WorkoutExerciseRowView {
    init(exercise: ExerciseInstance) {
        self.viewModel = WorkoutExerciseRowViewModel(group: nil, exercises: [exercise])
    }

    init(group: SetGroup, exercises: [ExerciseInstance]) {
        self.viewModel = WorkoutExerciseRowViewModel(group: group, exercises: exercises)
    }
}

#Preview {
    let metrics = [ExerciseMetric(type: .reps, isRequired: true), ExerciseMetric(type: .weight, isRequired: true)]
    let set = ExerciseSet(id: UUID(), metricValues: [.reps: 10, .weight: 50], notes: nil)
    let approach = Approach(set: set, drops: [])
    let exercise = ExerciseInstance(id: UUID(), exercise: Exercise(id: UUID(), name: "Push ups", description: "", mediaURL: nil, variations: [], muscleGroups: [], metrics: metrics), approaches: [approach], groupId: nil, notes: nil)
    return WorkoutExerciseRowView(exercise: exercise)
        .padding()
        .previewLayout(.sizeThatFits)
}
