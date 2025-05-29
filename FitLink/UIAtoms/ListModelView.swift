//
//  ListModelView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI

struct ListModeView: View {
    let todaySessions: [Session]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Today's Sessions")
                    .font(.headline)
                Spacer()
                Button(action: {
                    // Новая сессия на сегодня
                }) {
                    Label("New Session", systemImage: "plus")
                        .font(.subheadline.bold())
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)

            if todaySessions.isEmpty {
                Text("No sessions for today")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(todaySessions) { session in
                    SessionRow(session: session)
                        .padding(.horizontal)
                        .padding(.top, 8)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    ListModeView(todaySessions: Session.mockData)
}
