//
//  AvatarView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//

import SwiftUI

struct AvatarView: View {
    let initials: String
    var background: Color = Theme.color.accent.opacity(0.17)
    var foreground: Color = Theme.color.accent
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle()
                .fill(background)
            Text(initials)
                .font(.system(size: size * 0.42, weight: .semibold))
                .foregroundColor(foreground)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    AvatarView(initials: "DG")
}
