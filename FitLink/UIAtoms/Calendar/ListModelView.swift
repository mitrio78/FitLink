//
//  ListModelView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI

struct ListModeView: View {
    let todaySessions: [WorkoutSession]
    let clients: [UUID: Client]
    @Binding var selectedSession: WorkoutSession?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(NSLocalizedString("ScheduleList.TodayTitle", comment: "Сессии на сегодня"))
                    .font(.headline)
                Spacer()
                Button(action: {
                    // Новая сессия на сегодня
                }) {
                    Label(NSLocalizedString("ScheduleList.NewSession", comment: "Новая сессия"), systemImage: "plus")
                        .font(.subheadline.bold())
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)

            if todaySessions.isEmpty {
                Text(NSLocalizedString("ScheduleList.Empty", comment: "Нет сессий на сегодня"))
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(todaySessions) { session in
                    Button {
                        selectedSession = session
                    } label: {
                        SessionRow(
                            session: session,
                            client: session.clientId.flatMap { clients[$0] } ?? .placeholder
                        )
                        .contentShape(Rectangle())
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .buttonStyle(.plain)
                }
            }
            Spacer()
        }
    }
}

//#Preview {
//    ListModeView(todaySessions: mockSessions, selectedSession: nil)
//}
