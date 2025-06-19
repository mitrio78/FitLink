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
        // The index set we receive is based on the rows displayed in the list.
        // Row 0 is the main set and should never be removed. Drop sets start at
        // index 1 in `sets`. Convert the visual positions to the actual array
        // indices and ignore attempts to delete the main set.
        let adjustedOffsets = IndexSet(
            offsets
                .filter { $0 > 0 }
                .map { $0 + 1 }
        )

        guard !adjustedOffsets.isEmpty else { return }

        withAnimation {
            sets.remove(atOffsets: adjustedOffsets)
        }
    }

    func moveDrops(from offsets: IndexSet, to destination: Int) {
        sets.move(fromOffsets: offsets, toOffset: destination)
    }
}
