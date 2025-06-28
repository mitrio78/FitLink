import Foundation

@MainActor
final class WorkoutExerciseEditViewModel: ObservableObject {
    @Published var selectedExercises: [Exercise]
    /// Currently chosen workout section. Defaults to `.main`.
    @Published var selectedSection: WorkoutSection

    init(initialExercises: [Exercise] = [], section: WorkoutSection = .main) {
        self.selectedExercises = initialExercises
        self.selectedSection = section
    }

    var isSuperset: Bool { selectedExercises.count > 1 }

    func addExercise(_ exercise: Exercise) {
        selectedExercises.append(exercise)
    }

    func replaceExercise(at index: Int, with exercise: Exercise) {
        guard selectedExercises.indices.contains(index) else { return }
        selectedExercises[index] = exercise
    }

    /// Remove exercise at index. Returns `true` if no exercises remain.
    func removeExercise(at index: Int) -> Bool {
        guard selectedExercises.indices.contains(index) else { return false }
        selectedExercises.remove(at: index)
        return selectedExercises.isEmpty
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
                section: selectedSection
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
                    section: selectedSection
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
    case deleted
}
