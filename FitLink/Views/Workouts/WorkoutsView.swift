//
//  WorkoutsView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI

struct WorkoutsView: View {
    @StateObject private var viewModel = WorkoutsViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Total sessions: \(viewModel.workouts.count)")
        }
        .padding()
    }
}

#Preview {
    WorkoutsView()
}
