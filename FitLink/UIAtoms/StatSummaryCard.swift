//
//  Untitled.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI

// Stat Card
struct StatSummaryCard: View {
    let stat: StatSummary
    
    var body: some View {
        VStack(spacing: Theme.spacing.small / 2) {
            HStack {
                Image(systemName: stat.icon ?? "")
                    .foregroundColor(Theme.color.accent)
                Text("\(stat.value)")
                    .font(Theme.font.titleSmall).bold()
                    .foregroundColor(Theme.color.textPrimary)
            }
            Text(stat.title)
                .font(Theme.font.caption)
                .foregroundColor(Theme.color.textSecondary)
        }
        .frame(height: Theme.spacing.extraLarge * 2)
        .frame(maxWidth: .infinity)
        .background(Theme.color.backgroundSecondary)
        .cornerRadius(Theme.radius.card)
        .shadow(color: Theme.shadow.card.color,
                radius: Theme.shadow.card.radius,
                x: Theme.shadow.card.x,
                y: Theme.shadow.card.y)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radius.card)
                .stroke(Theme.color.border, lineWidth: 1)
        )
    }
}

#Preview { StatSummaryCard(stat: .init(id: "", title: "Hey", value: "Oho", icon: "", hasDot: true)) }
