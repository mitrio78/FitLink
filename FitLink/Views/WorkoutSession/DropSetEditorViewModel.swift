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
        // Offsets correspond to visible rows. Row 0 is the main set and should
        // be protected from deletion. Filter out attempts to delete it and
        // remove the remaining drop rows directly.
        let dropOffsets = IndexSet(offsets.filter { $0 > 0 })

        guard !dropOffsets.isEmpty else { return }

        withAnimation {
            sets.remove(atOffsets: dropOffsets)
        }
    }

    func moveDrops(from offsets: IndexSet, to destination: Int) {
        sets.move(fromOffsets: offsets, toOffset: destination)
    }
}
