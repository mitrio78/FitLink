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
    
    var body: some View {
        HStack {
            // Replace with AsyncImage in production
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(Text(client.name.prefix(1)).foregroundColor(.gray))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(client.name).font(.body.bold())
                Text("Last: \(client.lastSessionDescription)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                Text("Next: \(client.nextSession)")
                    .font(.caption)
                    .foregroundColor(.accentColor)
                    .lineLimit(1)
            }
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color(.systemGray4).opacity(0.18), radius: 2, x: 0, y: 1)
    }
}

struct ClientRow_Previews: PreviewProvider {
    static var previews: some View = ClientRow(client: .init(name: "John Doe", avatarURL: nil, lastSessionDescription: "12:00", nextSession: "14:00", nextSessionAccent: "#FF0000"))
        .previewLayout(.sizeThatFits)
}
