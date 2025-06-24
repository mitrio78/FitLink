import Foundation
import SwiftUI

@MainActor
final class WorkoutEditorStore: ObservableObject {
    @Published var activeSetDraft: DraftSet?

    func openNewSet(metrics: [ExerciseMetric]) {
        var units: [UUID: UnitType] = [:]
        for metric in metrics {
            units[metric.id] = defaultUnit(for: metric.type)
        }
        activeSetDraft = DraftSet(metricValues: [:], units: units, sourceSetID: nil)
    }

    func openEdit(set: ExerciseSet, metrics: [ExerciseMetric]) {
        var values: [UUID: Double] = [:]
        var units: [UUID: UnitType] = [:]
        for metric in metrics {
            if let value = set.metricValues[metric.type] {
                values[metric.id] = value
            }
            units[metric.id] = defaultUnit(for: metric.type)
        }
        activeSetDraft = DraftSet(metricValues: values, units: units, sourceSetID: set.id)
    }

    func save(draft: DraftSet) {
        // Implementation will be added later
    }

    private func defaultUnit(for type: ExerciseMetricType) -> UnitType {
        switch type {
        case .weight: return .kg
        case .reps: return .reps
        case .time: return .sec
        default: return .reps
        }
    }
}
