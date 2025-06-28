import Foundation
import Combine

@MainActor
final class ExerciseEditViewModel: ObservableObject {
    @Published var name: String
    @Published var description: String
    @Published var mediaURL: URL?
    @Published var variations: [String]
    @Published var newVariation: String = ""
    @Published var selectedGroups: Set<MuscleGroup>
    @Published var mainGroup: MuscleGroup?
    @Published var metrics: [ExerciseMetric]

    private let dataStore: AppDataStore
    private let exerciseId: UUID
    let isNew: Bool

    init(exercise: Exercise? = nil, dataStore: AppDataStore) {
        self.dataStore = dataStore
        if let exercise {
            self.isNew = false
            self.exerciseId = exercise.id
            self.name = exercise.name
            self.description = exercise.description ?? ""
            self.mediaURL = exercise.mediaURL
            self.variations = exercise.variations
            self.selectedGroups = Set(exercise.muscleGroups)
            self.mainGroup = exercise.mainMuscle
            self.metrics = exercise.metrics
        } else {
            self.isNew = true
            self.exerciseId = UUID()
            self.name = ""
            self.description = ""
            self.mediaURL = nil
            self.variations = []
            self.selectedGroups = []
            self.mainGroup = nil
            self.metrics = []
        }
    }

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && !selectedGroups.isEmpty
    }

    func addVariation() {
        let value = newVariation.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else { return }
        variations.append(value)
        newVariation = ""
    }

    func removeVariation(at offsets: IndexSet) {
        variations.remove(atOffsets: offsets)
    }

    func toggleGroup(_ group: MuscleGroup) {
        if selectedGroups.contains(group) {
            selectedGroups.remove(group)
            if mainGroup == group { mainGroup = selectedGroups.first }
        } else {
            selectedGroups.insert(group)
            if mainGroup == nil { mainGroup = group }
        }
    }

    func addMetric() {
        metrics.append(ExerciseMetric(type: .reps, unit: nil, isRequired: false))
    }

    func removeMetric(at offsets: IndexSet) {
        metrics.remove(atOffsets: offsets)
    }

    func save() {
        guard canSave else { return }
        let exercise = Exercise(
            id: exerciseId,
            name: name,
            description: description.isEmpty ? nil : description,
            mediaURL: mediaURL,
            variations: variations,
            muscleGroups: Array(selectedGroups),
            metrics: metrics
        )
        dataStore.saveExercise(exercise)
    }
}

