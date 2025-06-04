//
//  CalendarModeView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//
import SwiftUI

struct CalendarModeView: View {
    @Binding var selectedDate: Date
    let sessions: [WorkoutSession]
    let filteredSessions: [WorkoutSession]
    let clients: [UUID: Client]     // Прокидываем клиентов

    var body: some View {
        VStack(spacing: 0) {
            DatePicker(
                selectedDate.formatted(date: .long, time: .omitted),
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding(.horizontal)

            Divider()
                .padding(.bottom, 24)

            HStack {
                Text(selectedDate.formatted(date: .long, time: .omitted))
                    .font(.headline)
                Spacer()
                Button(action: {
                    // Добавить сессию на выбранную дату
                }) {
                    Label(NSLocalizedString("CalendarMode.AddSession", comment: "Добавить сессию"), systemImage: "plus")
                        .font(.subheadline.bold())
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)

            if filteredSessions.isEmpty {
                Text(NSLocalizedString("CalendarMode.Empty", comment: "Нет запланированных сессий"))
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(filteredSessions) { session in
                    // Получаем клиента для каждой сессии по clientId (если нет, показываем заглушку)
                    SessionRow(
                        session: session,
                        client: session.clientId.flatMap { clients[$0] } ?? .placeholder
                    )
                    .padding(.horizontal)
                    .padding(.top, 6)
                }
            }
            Spacer()
        }
    }
}
