//
//  SearchBarWithFilter.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 28.05.2025.
//

import SwiftUI

struct SearchBarWithFilter: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    var placeholder: String = NSLocalizedString("SearchBar.DefaultPlaceholder", comment: "Search...")
    var onFilterTapped: (() -> Void)? = nil

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .font(.subheadline)
                .onSubmit {
                    isFocused = false // теряем фокус
                    hideKeyboard()
                }

            Button(action: {
                onFilterTapped?()
            }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .padding(.leading, 2)
        }
    }
}

// Preview для UI атома
struct SearchBarWithFilter_Previews: PreviewProvider {
    @State static var text = ""
    static var previews: some View {
        SearchBarWithFilter(text: $text, placeholder: "Search clients...") { }
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
