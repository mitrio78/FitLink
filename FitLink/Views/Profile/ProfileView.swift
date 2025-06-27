//
//  ProfileView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//


import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(viewModel.username)
            Spacer()

#if DEBUG
            // Developer-only settings section
            VStack(alignment: .leading, spacing: Theme.spacing.small) {
                Text(NSLocalizedString("DeveloperSettings.SectionTitle", comment: "Developer Settings"))
                    .font(Theme.font.subheading)
                    .foregroundColor(Theme.color.textSecondary)

                Toggle(
                    NSLocalizedString("DeveloperSettings.CompactMode", comment: "Compact UI Mode"),
                    isOn: $settings.isCompactModeEnabled
                )
            }
            .padding(.top, Theme.spacing.large)
#endif
        }
        .padding()
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppSettings.shared)
}
