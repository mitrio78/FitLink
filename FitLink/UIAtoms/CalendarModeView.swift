//
//  CalendarModeView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//
import SwiftUI

struct CalendarModeView: View {
    @Binding var selectedDate: Date
    let sessions: [Session]
    let filteredSessions: [Session]

    var body: some View {
        VStack(spacing: 0) {
            // Здесь можно использовать кастомный календарь
            // Для MVP — просто DatePicker, позже интегрировать FSCalendar или SwiftUI календарь
            DatePicker(
                "June 2024", selection: $selectedDate,
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
                    Label("Add Session", systemImage: "plus")
                        .font(.subheadline.bold())
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)

            // Список сессий на выбранную дату
            if filteredSessions.isEmpty {
                Text("No sessions scheduled")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(filteredSessions) { session in
                    SessionRow(session: session)
                        .padding(.horizontal)
                        .padding(.top, 6)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    CalendarModeView(selectedDate: .constant(Date()), sessions: Session.mockData, filteredSessions: Session.mockData)
}
