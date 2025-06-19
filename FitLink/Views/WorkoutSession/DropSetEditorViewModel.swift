import Foundation
import SwiftUI

@MainActor
final class DropSetEditorViewModel: ObservableObject {
    @Published var sets: [ExerciseSet]
    let metrics: [ExerciseMetric]

    init(sets: [ExerciseSet], metrics: [ExerciseMetric]) {
        self.sets = sets
        self.metrics = metrics
    }

    func addDrop() {
        withAnimation {
            sets.append(ExerciseSet(id: UUID(), metricValues: [:], notes: nil, drops: nil))
        }
    }

    func deleteDrops(at offsets: IndexSet) {
        withAnimation {
            sets.remove(atOffsets: offsets)
        }
    }

    func moveDrops(from offsets: IndexSet, to destination: Int) {
        sets.move(fromOffsets: offsets, toOffset: destination)
    }
}
