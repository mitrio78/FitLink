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
    @Binding var selectedSession: WorkoutSession?
    let clients: [UUID: Client]

    init(viewModel: ScheduleViewModel, selectedSession: Binding<WorkoutSession?>, clients: [UUID: Client]) {
        self.viewModel = viewModel
        _monthDate = State(initialValue: viewModel.selectedDate)
        self._selectedSession = selectedSession
        self.clients = clients
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
                Text(NSLocalizedString("ScheduleCalendar.Empty", comment: "Нет занятий на эту дату"))
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(daySessions) { session in
                    Button {
                        selectedSession = session
                    } label: {
                        SessionRow(
                            session: session,
                            client: session.clientId.flatMap { clients[$0] } ?? .placeholder
                        )
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                    .buttonStyle(.plain)
                }
            }
            Spacer()
        }
        .padding(.top)
    }
}

#if DEBUG
struct ScheduleCalendarContainer_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleCalendarContainer(
            viewModel: ScheduleViewModel(),
            selectedSession: .constant(nil),
            clients: [:]
        )
        .previewLayout(.sizeThatFits)
    }
}
#endif
