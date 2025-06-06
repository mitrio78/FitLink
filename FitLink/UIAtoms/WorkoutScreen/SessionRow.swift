//
//  SessionRow.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI

struct SessionRow: View {
    let session: WorkoutSession
    let client: Client

    var body: some View {
        HStack {
            InitialsCircle(initials: client.initials)
                .frame(width: 44, height: 44)
                .padding(.trailing, Theme.spacing.small)

            VStack(alignment: .leading, spacing: 2) {
                Text(client.name)
                    .font(Theme.font.body).bold()
                Text(session.title)
                    .font(Theme.font.caption)
                    .foregroundColor(Theme.color.textSecondary)
            }
            Spacer()
            statusLabel
            Text(session.timeString)
                .font(Theme.font.subheading).bold()
                .padding(.leading, Theme.spacing.medium)
        }
        .padding(Theme.spacing.medium)
        .background(Theme.color.backgroundSecondary)
        .cornerRadius(Theme.radius.card)
        .shadow(color: Theme.shadow.card.color,
                radius: Theme.shadow.card.radius,
                x: Theme.shadow.card.x,
                y: Theme.shadow.card.y)
        .padding(.bottom, Theme.spacing.small)
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
                .padding(Theme.spacing.small)
                .background(session.status.backgroundColor)
                .cornerRadius(Theme.radius.button)
        }
    }
}

struct InitialsCircle: View {
    let initials: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Theme.color.accent.opacity(0.13))
            Text(initials.uppercased())
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Theme.color.accent)
        }
    }
}

#if DEBUG
struct SessionRow_Previews: PreviewProvider {
    static var previews: some View {
        let session = WorkoutSession(id: UUID(), clientId: nil, title: "Тренировка", date: Date(), exerciseInstances: [], setGroups: nil, notes: nil, status: .planned)
        let client = Client(id: UUID(), name: "Иван Петров", avatarURL: nil)
        SessionRow(session: session, client: client)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
