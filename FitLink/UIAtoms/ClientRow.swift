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
        HStack(alignment: .center, spacing: 14) {
            AvatarView(initials: client.initials)
                .frame(width: 44, height: 44)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(client.name)
                    .font(.body.bold())
                    .foregroundColor(.primary)
                
                if let lastSession = lastSession {
                    Text(String(format: NSLocalizedString("ClientRow.LastSession", comment: "Последняя: %@ • %@"), lastSession.timeString, lastSession.date?.formattedHuman() ?? ""))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let nextSession = nextSession {
                    Text(String(format: NSLocalizedString("ClientRow.NextSession", comment: "Следующая: %@ • %@"), nextSession.timeString, nextSession.date?.formattedHuman() ?? ""))
                        .font(.caption)
                        .foregroundColor(Color(.label))
                        .padding(.vertical, 2)
                        .padding(.horizontal, 6)
                        .background(Color(.systemOrange).opacity(0.13))
                        .cornerRadius(8)
                }
            }
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        //.frame(minHeight: 86)
    }
}

#Preview {
    ClientRow(client: .init(id: UUID(), name: "Joe", avatarURL: nil), lastSession: nil, nextSession: nil)
}
