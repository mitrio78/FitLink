//
//  ScheduleCalendarContainer.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI

struct ScheduleCalendarContainer: View {
    @ObservedObject var viewModel: ScheduleViewModel
    @State private var monthDate: Date

    init(viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
        _monthDate = State(initialValue: viewModel.selectedDate)
    }

    var body: some View {
        VStack {
            CustomCalendarView(
                selectedDate: $viewModel.selectedDate,
                eventsByDate: viewModel.sessionsByDate,
                monthDate: monthDate
            )
            .onChange(of: viewModel.selectedDate) {
                monthDate = viewModel.selectedDate
            }

            Divider().padding(.vertical, 6)

            let daySessions = viewModel.sessionsByDate[Calendar.current.startOfDay(for: viewModel.selectedDate)] ?? []
            if daySessions.isEmpty {
                Text("Нет занятий на эту дату")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(daySessions) { session in
                    SessionRow(session: session)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
            }
            Spacer()
        }
        .padding(.top)
    }
}
