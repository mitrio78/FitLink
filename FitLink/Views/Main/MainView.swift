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
                    Label(NSLocalizedString("Main.Tab.Dashboard", comment: "Dashboard"), systemImage: "house")
                }
            ExerciseLibraryView()
                .tabItem {
                    Label(NSLocalizedString("Main.Tab.Exercises", comment: "Exercises"), systemImage: "list.bullet.rectangle")
                }
            ScheduleView()
                .tabItem {
                    Label(NSLocalizedString("Main.Tab.Schedule", comment: "Schedule"), systemImage: "calendar")
                }
            WorkoutsView()
                .tabItem {
                    Label(NSLocalizedString("Main.Tab.Workouts", comment: "Workouts"), systemImage: "dumbbell")
                }
            ProfileView()
                .tabItem {
                    Label(NSLocalizedString("Main.Tab.Profile", comment: "Profile"), systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    MainView()
}
