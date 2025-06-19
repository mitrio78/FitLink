import Foundation

@MainActor
final class DropSetEditorViewModel: ObservableObject {
    @Published var sets: [ExerciseSet]
    let metrics: [ExerciseMetric]

    init(sets: [ExerciseSet], metrics: [ExerciseMetric]) {
        self.sets = sets
        self.metrics = metrics
    }

    func addDrop() {
        sets.append(ExerciseSet(id: UUID(), metricValues: [:], notes: nil, drops: nil))
    }

    func deleteDrops(at offsets: IndexSet) {
        sets.remove(atOffsets: offsets)
    }

    func moveDrops(from offsets: IndexSet, to destination: Int) {
        sets.move(fromOffsets: offsets, toOffset: destination)
    }
}
