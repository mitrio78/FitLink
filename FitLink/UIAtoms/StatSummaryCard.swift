//
//  Untitled.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI

// Stat Card
struct StatSummaryCard: View {
    let stat: StatCard
    
    var body: some View {
        VStack(spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
            HStack(spacing: 4) {
                Text(stat.value)
                    .font(.title2.bold())
                if stat.hasDot {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                }
            }
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }
}

#Preview {
    StatSummaryCard(stat: .init(title: "Загружено", value: "123", hasDot: true))
}
