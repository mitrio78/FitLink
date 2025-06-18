//
//  ProfileView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//


import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(viewModel.username)
        }
        .padding()
    }
}

#Preview {
    ProfileView()
}
