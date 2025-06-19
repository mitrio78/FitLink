//
//  FitLinkApp.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI

@main
struct FitLinkApp: App {
    @StateObject private var dataStore = AppDataStore.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(dataStore)
        }
    }
}
