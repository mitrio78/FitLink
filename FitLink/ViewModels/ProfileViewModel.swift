import Foundation
import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var username: String = ""

    init(username: String = "Trainer") {
        self.username = username
    }
}
