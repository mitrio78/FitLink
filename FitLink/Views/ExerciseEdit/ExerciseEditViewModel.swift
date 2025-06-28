import Foundation
import Combine
import UniformTypeIdentifiers

@MainActor
final class ExerciseEditViewModel: ObservableObject {
    @Published var name: String
    @Published var description: String
    @Published var mediaURL: URL?
    @Published var errorMessage: String?
    @Published var isProcessingMedia: Bool = false
    @Published var variations: [String]
    @Published var newVariation: String = ""
    @Published var selectedGroups: Set<MuscleGroup>
    @Published var mainGroup: MuscleGroup?
    @Published var metrics: [ExerciseMetric]

    private let dataStore: AppDataStore
    private let exerciseId: UUID
    let isNew: Bool
    private let originalMediaURL: URL?

    init(exercise: Exercise? = nil, dataStore: AppDataStore) {
        self.dataStore = dataStore
        if let exercise {
            self.isNew = false
            self.exerciseId = exercise.id
            self.name = exercise.name
            self.description = exercise.description ?? ""
            self.mediaURL = exercise.mediaURL
            self.originalMediaURL = exercise.mediaURL
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
            self.originalMediaURL = nil
            self.variations = []
            self.selectedGroups = []
            self.mainGroup = nil
            self.metrics = []
        }
    }

    /// Attach a media file selected by the user.
    func onMediaSelected(tempURL: URL) {
        Task {
            isProcessingMedia = true
            do {
                let exercise = currentExercise
                let url = try await dataStore.updateMedia(for: exercise, with: tempURL)
                mediaURL = url
            } catch {
                errorMessage = error.localizedDescription
            }
            isProcessingMedia = false
        }
    }

    /// Remove currently attached media from disk and model.
    func removeMedia() {
        Task {
            isProcessingMedia = true
            do {
                let exercise = currentExercise
                try await dataStore.removeMedia(for: exercise)
                mediaURL = nil
            } catch {
                errorMessage = error.localizedDescription
            }
            isProcessingMedia = false
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

    /// Determines if the given media URL represents a video file.
    func mediaIsVideo(_ url: URL) -> Bool {
        if let type = UTType(filenameExtension: url.pathExtension) {
            return type.conforms(to: .movie)
        }
        return false
    }

    /// Cleans up temporary media if the editor is cancelled.
    func cancel() {
        guard mediaURL != originalMediaURL else { return }
        Task {
            do {
                let exercise = currentExercise
                try await dataStore.removeMedia(for: exercise)
                mediaURL = originalMediaURL
            } catch {
                // Ignore cleanup failures
            }
        }
    }

    func save() {
        guard canSave else { return }
        let exercise = currentExercise
        dataStore.saveExercise(exercise)
    }
}

