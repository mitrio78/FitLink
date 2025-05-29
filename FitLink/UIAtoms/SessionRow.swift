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
            if session.status == .pending {
                Label("Pending", systemImage: "clock")
                    .font(.caption2)
                    .foregroundColor(.orange)
                    .padding(6)
                    .background(Color.orange.opacity(0.12))
                    .cornerRadius(8)
            } else if session.status == .completed {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title3)
            } else if session.status == .cancelled {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .font(.title3)
            }
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
}

#Preview {
    SessionRow(session: .init(clientName: "John Doe", clientAvatar: "person.circle", workoutTitle: "Yoga", date: Date(), time: "10:00 AM", status: .pending))
}
