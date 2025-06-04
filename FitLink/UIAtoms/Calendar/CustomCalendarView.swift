//
//  ElegantCalendarView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import Foundation
import SwiftUI
struct CustomCalendarView: View {
    @Binding var selectedDate: Date
    let eventsByDate: [Date: [WorkoutSession]]
    let monthDate: Date
    let calendar = Calendar.current

    // Получить цвета точек по статусам для конкретной даты
    func statusColors(for date: Date) -> [Color] {
        let sessions = eventsByDate[calendar.startOfDay(for: date)] ?? []
        return sessions.map { $0.status.color }
    }

    // ... сгенерируй сетку дней (как выше)
    var days: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: monthDate),
            let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end.addingTimeInterval(-1))
        else { return [] }
        var days: [Date] = []
        var date = firstWeek.start
        while date <= lastWeek.end {
            days.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        return days
    }

    var body: some View {
        let weekdays = calendar.shortWeekdaySymbols
        VStack {
            // Месяц и кнопки навигации
            HStack {
                Button(action: {
                    guard let prevMonth = calendar.date(byAdding: .month, value: -1, to: monthDate) else { return }
                    selectedDate = prevMonth
                }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(monthDate, format: .dateTime.year().month(.wide))
                    .font(.headline)
                Spacer()
                Button(action: {
                    guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: monthDate) else { return }
                    selectedDate = nextMonth
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            .padding(8)

            // Дни недели
            HStack {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                }
            }

            // Календарная сетка
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(days, id: \.self) { date in
                    let inCurrentMonth = calendar.isDate(date, equalTo: monthDate, toGranularity: .month)
                    VStack(spacing: 2) {
                        // Если день принадлежит текущему месяцу — рисуем число и точки
                        if inCurrentMonth {
                            Text("\(calendar.component(.day, from: date))")
                                .fontWeight(calendar.isDate(date, inSameDayAs: selectedDate) ? .bold : .regular)
                                .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ? .white : .primary)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(calendar.isDate(date, inSameDayAs: selectedDate) ? Color.blue : Color.clear)
                                )
                            // Точки
                            HStack(spacing: 2) {
                                let colors = statusColors(for: date)
                                ForEach(Array(colors.prefix(3)).indices, id: \.self) { i in
                                    Circle()
                                        .fill(colors[i])
                                        .frame(width: 6, height: 6)
                                }
                                if colors.count > 3 {
                                    Text("+")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(height: 8)
                        } else {
                            // Вне месяца — просто placeholder (никаких точек)
                            Text("")
                                .frame(width: 32, height: 32)
                            Spacer().frame(height: 8)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if inCurrentMonth {
                            selectedDate = date
                        }
                    }
                } // - ForEach
            } // - LazyVGrid
        }
    }
}
