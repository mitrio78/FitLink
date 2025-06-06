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
                .foregroundColor(configuration.isOn ? Theme.color.accent : Theme.color.textSecondary)
                .imageScale(.large)
        }
        .buttonStyle(.plain)
    }
}

#if DEBUG
struct CheckboxToggleStyle_Previews: PreviewProvider {
    @State static var isOn = true
    static var previews: some View {
        Toggle("Checkbox", isOn: $isOn)
            .toggleStyle(CheckboxToggleStyle())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
