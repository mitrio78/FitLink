//
//  DraftSet.swift
//  FitLink
//
//  Created by OpenAI on 2025-06-01.
//

import Foundation

extension ExerciseMetric {
    typealias ID = ExerciseMetricType
    var id: ID { type }
}

/// Temporary representation of an exercise set used during editing.
struct DraftSet: Identifiable, Equatable {
    let id: UUID
    var metricValues: [ExerciseMetric.ID: Double]
    var metricUnits: [ExerciseMetric.ID: UnitType]
    var sourceSetID: UUID?
}

extension DraftSet {
    /// Default unit for a given metric
    static func defaultUnit(for metric: ExerciseMetric) -> UnitType {
        if let unit = metric.unit { return unit }
        switch metric.type {
        case .reps: return .repetition
        case .weight: return .kilogram
        case .time: return .second
        case .distance: return .meter
        case .calories: return .calorie
        case .custom:
            return .custom("")
        }
    }

    /// Create a new draft for the provided metrics
    static func newDraft(for metrics: [ExerciseMetric]) -> DraftSet {
        let values = Dictionary(uniqueKeysWithValues: metrics.map { ($0.id, 0.0) })
        let units = Dictionary(uniqueKeysWithValues: metrics.map { ($0.id, defaultUnit(for: $0)) })
        return DraftSet(id: UUID(), metricValues: values, metricUnits: units, sourceSetID: nil)
    }

    /// Initialize draft from existing set and metrics
    static func from(set: ExerciseSet, metrics: [ExerciseMetric]) -> DraftSet {
        var values: [ExerciseMetric.ID: Double] = [:]
        var units: [ExerciseMetric.ID: UnitType] = [:]
        for metric in metrics {
            values[metric.id] = set.metricValues[metric.type] ?? 0.0
            units[metric.id] = defaultUnit(for: metric)
        }
        return DraftSet(id: UUID(), metricValues: values, metricUnits: units, sourceSetID: set.id)
    }
}
