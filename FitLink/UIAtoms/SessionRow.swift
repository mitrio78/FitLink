//
//  SessionRow.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI

struct SessionRow: View {
    let session: Session

    var body: some View {
        HStack {
            Image(systemName: session.clientAvatar ?? "person.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .clipShape(Circle())
                .padding(.trailing, 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(session.clientName)
                    .font(.body.bold())
                Text(session.workoutTitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            statusLabel
            Text(session.time)
                .font(.subheadline.bold())
                .padding(.leading, 12)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(14)
        .shadow(color: Color(.systemGray4).opacity(0.10), radius: 3, x: 0, y: 1)
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private var statusLabel: some View {
        switch session.status {
        case .planned:
            Label("Запланировано", systemImage: "calendar")
                .font(.caption2)
                .foregroundColor(.blue)
                .padding(6)
                .background(Color.blue.opacity(0.12))
                .cornerRadius(8)
        case .inProgress:
            Label("В процессе", systemImage: "bolt.fill")
                .font(.caption2)
                .foregroundColor(.orange)
                .padding(6)
                .background(Color.orange.opacity(0.12))
                .cornerRadius(8)
        case .completed:
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title3)
        case .cancelled:
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
                .font(.title3)
        }
    }
}

#Preview {
    SessionRow(session: Session(
        clientId: UUID(),
        clientName: "Анна Петрова",
        clientAvatar: nil,
        workoutTitle: "Жим лёжа",
        date: Date(),
        time: "10:00",
        status: .planned
    ))
}
