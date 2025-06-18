import Foundation

@MainActor
final class MetricEditorViewModel: ObservableObject {
    @Published var approaches: [Approach]
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
}
