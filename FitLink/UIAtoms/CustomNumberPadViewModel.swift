import Foundation
import SwiftUI

@MainActor
final class CustomNumberPadViewModel: ObservableObject {
    let metrics: [ExerciseMetric]

    @Published var input: String
    @Published var selectedMetricId: ExerciseMetric.ID
    @Published var metricUnits: [ExerciseMetric.ID: UnitType]
    @Published var selectedUnit: UnitType

    init(metrics: [ExerciseMetric], values: [ExerciseMetric.ID: Double]) {
        let sorted = metrics.sorted { $0.type.sortIndex < $1.type.sortIndex }
        self.metrics = sorted
        let firstMetric = sorted.first!
        let defaultUnits = Dictionary(uniqueKeysWithValues: sorted.map { ($0.id, DraftSet.defaultUnit(for: $0)) })
        self.metricUnits = defaultUnits
        self.selectedMetricId = firstMetric.id
        self.selectedUnit = defaultUnits[firstMetric.id] ?? firstMetric.unit ?? .repetition
        let firstVal = values[firstMetric.id] ?? 0
        self.input = firstVal.numberPadString()
    }

    var currentMetric: ExerciseMetric {
        metrics.first { $0.id == selectedMetricId } ?? metrics[0]
    }

    func metric(for id: ExerciseMetric.ID) -> ExerciseMetric {
        metrics.first { $0.id == id } ?? metrics[0]
    }

    var unit: UnitType {
        metricUnits[selectedMetricId] ?? currentMetric.unit ?? .repetition
    }

    var unitOptions: [UnitType] { unit.numberPadOptions }

    var inputLabel: String? { unit.numberPadLabel }

    var isValid: Bool { Double(input) != nil }

    func updateSelection(to newID: ExerciseMetric.ID, values: [ExerciseMetric.ID: Double]) {
        selectedMetricId = newID
        let metric = metric(for: newID)
        selectedUnit = metricUnits[newID] ?? DraftSet.defaultUnit(for: metric)
        let newValue = values[newID] ?? 0
        input = newValue.numberPadString()
    }
}
