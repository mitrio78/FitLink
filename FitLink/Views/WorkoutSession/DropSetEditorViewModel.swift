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
        // `List` supplies indexes starting from the first deletable row.
        // Since the main set (row 0) isn't deletable, shift each index by +1
        // to target the matching element in `sets`.
        let actualOffsets = IndexSet(offsets.map { $0 + 1 })

        withAnimation {
            sets.remove(atOffsets: actualOffsets)
        }
    }

    func moveDrops(from offsets: IndexSet, to destination: Int) {
        sets.move(fromOffsets: offsets, toOffset: destination)
    }
}
