import Foundation

@MainActor
struct DropEditContext: Identifiable {
    let id = UUID()
    let index: Int
}

final class MetricEditorViewModel: ObservableObject {
    @Published var approaches: [Approach]
    @Published var dropEditContext: DropEditContext? = nil
    let metrics: [ExerciseMetric]

    init(approaches: [Approach], metrics: [ExerciseMetric]) {
        self.approaches = approaches
        self.metrics = metrics
    }

    func addApproach() {
        let emptySet = ExerciseSet(id: UUID(), metricValues: [:], notes: nil, drops: nil)
        approaches.append(Approach(sets: [emptySet]))
    }

    func removeApproach(at offsets: IndexSet) {
        approaches.remove(atOffsets: offsets)
    }

    func editDrops(for index: Int) {
        dropEditContext = DropEditContext(index: index)
    }

    func updateDrops(at index: Int, sets: [ExerciseSet]) {
        approaches[index].sets = sets
        dropEditContext = nil
    }
}
