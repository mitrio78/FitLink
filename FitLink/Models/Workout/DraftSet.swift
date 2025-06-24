import Foundation

/// Temporary editing model for exercise sets.
struct DraftSet: Identifiable, Equatable {
    var id: UUID = UUID()
    var metricValues: [UUID: Double]
    var units: [UUID: UnitType]
    var sourceSetID: UUID?

    init(id: UUID = UUID(),
         metricValues: [UUID: Double] = [:],
         units: [UUID: UnitType] = [:],
         sourceSetID: UUID? = nil) {
        self.id = id
        self.metricValues = metricValues
        self.units = units
        self.sourceSetID = sourceSetID
    }
}
