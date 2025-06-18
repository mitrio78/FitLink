import Foundation

@MainActor
final class WorkoutExerciseEditViewModel: ObservableObject {
    @Published var selectedExercises: [Exercise] = []

    var isSuperset: Bool { selectedExercises.count > 1 }

    func addExercise(_ exercise: Exercise) {
        selectedExercises.append(exercise)
    }

    func replaceExercise(at index: Int, with exercise: Exercise) {
        guard selectedExercises.indices.contains(index) else { return }
        selectedExercises[index] = exercise
    }

    func confirmSelection() -> WorkoutExerciseEditResult? {
        guard !selectedExercises.isEmpty else { return nil }
        if selectedExercises.count == 1, let exercise = selectedExercises.first {
            let instance = ExerciseInstance(
                id: UUID(),
                exercise: exercise,
                approaches: [],
                groupId: nil,
                notes: nil,
                section: .main
            )
            return .single(instance)
        } else {
            let groupId = UUID()
            let instances: [ExerciseInstance] = selectedExercises.map { ex in
                ExerciseInstance(
                    id: UUID(),
                    exercise: ex,
                    approaches: [],
                    groupId: groupId,
                    notes: nil,
                    section: .main
                )
            }
            let group = SetGroup(
                id: groupId,
                type: .superset,
                exerciseInstanceIds: instances.map { $0.id },
                repeatCount: nil,
                notes: nil
            )
            return .superset(group: group, exercises: instances)
        }
    }
}

enum WorkoutExerciseEditResult {
    case single(ExerciseInstance)
    case superset(group: SetGroup, exercises: [ExerciseInstance])
}
