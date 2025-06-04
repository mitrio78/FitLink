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
        VStack(spacing: 4) {
            HStack {
                Image(systemName: stat.icon ?? "")
                    .foregroundColor(.accentMain)
                Text("\(stat.value)")
                    .font(.title3.bold())
                    .foregroundColor(Color(.label))
            }
            Text(stat.title)
                .font(.footnote)
                .foregroundColor(Color(.secondaryLabel))
        }
        .frame(height: 64)
        .frame(maxWidth: .infinity)
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 3, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}

#Preview { StatSummaryCard(stat: .init(id: "", title: "Hey", value: "Oho", icon: "", hasDot: true)) }
