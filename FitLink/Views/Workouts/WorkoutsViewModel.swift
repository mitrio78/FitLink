import Foundation
import SwiftUI

@MainActor
final class WorkoutsViewModel: ObservableObject {
    @Published var workouts: [WorkoutSession] = []
    private let dataStore: AppDataStore

    init(dataStore: AppDataStore = .shared) {
        self.dataStore = dataStore

        dataStore.$sessions
            .assign(to: &$workouts)
    }
}
