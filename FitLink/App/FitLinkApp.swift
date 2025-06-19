//
//  FitLinkApp.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI

@main
struct FitLinkApp: App {
    @StateObject private var store = WorkoutStore()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(store)
        }
    }
}
