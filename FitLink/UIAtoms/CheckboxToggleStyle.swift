//
//  CheckboxToggleStyle.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                .imageScale(.large)
        }
        .buttonStyle(.plain)
    }
}
