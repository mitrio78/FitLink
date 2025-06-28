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

    /// Attach a media file selected by the user.
    func onMediaSelected(tempURL: URL) {
        Task {
            do {
                let exercise = currentExercise
                let url = try await dataStore.updateMedia(for: exercise, with: tempURL)
                mediaURL = url
            } catch {
                // In real UI this would trigger a user-facing alert.
                print("Failed to save media: \(error)")
            }
        }
    }

    /// Remove currently attached media from disk and model.
    func removeMedia() {
        Task {
            do {
                let exercise = currentExercise
                try await dataStore.removeMedia(for: exercise)
                mediaURL = nil
            } catch {
                print("Failed to remove media: \(error)")
            }
        }
    }

    /// Returns the current exercise representation based on editor state.
    private var currentExercise: Exercise {
        var groups: [MuscleGroup] = []
        if let mainGroup { groups.append(mainGroup) }
        groups.append(contentsOf: selectedGroups.filter { $0 != mainGroup })
        let sortedMetrics = metrics.sorted { $0.type.sortOrder < $1.type.sortOrder }
        return Exercise(
            id: exerciseId,
            name: name,
            description: description.isEmpty ? nil : description,
            mediaURL: mediaURL,
            variations: variations,
            muscleGroups: groups,
            metrics: sortedMetrics
        )
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
        metrics.append(ExerciseMetric(type: .reps, unit: .repetition, isRequired: false))
    }

    func removeMetric(at offsets: IndexSet) {
        metrics.remove(atOffsets: offsets)
    }

    func save() {
        guard canSave else { return }
        let exercise = currentExercise
        dataStore.saveExercise(exercise)
    }
}

