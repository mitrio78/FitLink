//
//  MainView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            TrainerDashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }
            ExerciseLibraryView()
                .tabItem {
                    Label("Exercises", systemImage: "list.bullet.rectangle")
                }
            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
            WorkoutsView()
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    MainView()
}
