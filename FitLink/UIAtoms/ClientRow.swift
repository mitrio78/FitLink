//
//  Untitled.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//
import SwiftUI

// Client Row
struct ClientRow: View {
    let client: Client
    let lastSession: WorkoutSession?
    let nextSession: WorkoutSession?
    
    var body: some View {
        HStack(alignment: .center, spacing: Theme.spacing.medium - 2) {
            AvatarView(initials: client.initials)
                .frame(width: 44, height: 44)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(client.name)
                    .font(Theme.font.body).bold()
                    .foregroundColor(Theme.color.textPrimary)
                
                if let lastSession = lastSession {
                    Text(String(format: NSLocalizedString("ClientRow.LastSession", comment: "Последняя: %@ • %@"), lastSession.timeString, lastSession.date?.formattedHuman() ?? ""))
                        .font(Theme.font.caption)
                        .foregroundColor(Theme.color.textSecondary)
                }
                
                if let nextSession = nextSession {
                    Text(String(format: NSLocalizedString("ClientRow.NextSession", comment: "Следующая: %@ • %@"), nextSession.timeString, nextSession.date?.formattedHuman() ?? ""))
                        .font(Theme.font.caption)
                        .foregroundColor(Theme.color.textPrimary)
                        .padding(.vertical, Theme.spacing.small / 4)
                        .padding(.horizontal, Theme.spacing.small - 2)
                        .background(Theme.color.accent.opacity(0.13))
                        .cornerRadius(Theme.radius.button)
                }
            }
            Spacer()
        }
        .padding(.vertical, Theme.spacing.small + 2)
        .padding(.horizontal, Theme.spacing.small + 2)
        .background(Theme.color.backgroundSecondary)
        .cornerRadius(Theme.radius.card)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radius.card)
                .stroke(Theme.color.border, lineWidth: 1)
        )
        //.frame(minHeight: 86)
    }
}

#Preview {
    ClientRow(client: .init(id: UUID(), name: "Joe", avatarURL: nil), lastSession: nil, nextSession: nil)
}
