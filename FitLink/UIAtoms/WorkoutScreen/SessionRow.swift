//
//  SessionRow.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI

import SwiftUI

struct SessionRow: View {
    let session: WorkoutSession
    let client: Client

    var body: some View {
        HStack {
            InitialsCircle(initials: client.initials)
                .frame(width: 44, height: 44)
                .padding(.trailing, 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(client.name)
                    .font(.body.bold())
                Text(session.title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            statusLabel
            Text(session.timeString)
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
        if session.status == .completed || session.status == .cancelled {
            Image(systemName: session.status.iconName)
                .foregroundColor(session.status.color)
                .font(.title3)
        } else {
            Label(session.status.labelText, systemImage: session.status.iconName)
                .font(.caption2)
                .foregroundColor(session.status.color)
                .padding(6)
                .background(session.status.backgroundColor)
                .cornerRadius(8)
        }
    }
}

struct InitialsCircle: View {
    let initials: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.accentColor.opacity(0.13))
            Text(initials.uppercased())
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.accentColor)
        }
    }
}
