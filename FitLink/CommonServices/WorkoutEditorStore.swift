//
//  WorkoutEditorStore.swift
//  FitLink
//
//  Created by OpenAI on 2025-06-01.
//

import Foundation
import SwiftUI

@MainActor
final class WorkoutEditorStore: ObservableObject {
    @Published var activeSetDraft: DraftSet?

    func openNewSet(for metrics: [ExerciseMetric]) {
        activeSetDraft = DraftSet.newDraft(for: metrics)
    }

    func openEdit(set: ExerciseSet, metrics: [ExerciseMetric]) {
        activeSetDraft = DraftSet.from(set: set, metrics: metrics)
    }

    func save(draft: DraftSet) {
        // Persistence handled elsewhere
    }
}
