import Foundation
import SwiftUI

@MainActor
final class WorkoutsViewModel: ObservableObject {
    @Published var workouts: [WorkoutSession]

    init(workouts: [WorkoutSession] = MockData.complexMockSessions) {
        self.workouts = workouts
    }
}
