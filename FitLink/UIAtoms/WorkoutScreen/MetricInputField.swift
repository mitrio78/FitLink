import SwiftUI

/// Editable numeric field with optional prefix and suffix.
struct MetricInputField: View {
    @Binding var value: Double?
    var placeholder: String = "0"
    var prefix: String? = nil
    var suffix: String? = nil
    var keyboardType: UIKeyboardType = .decimalPad
    var onCommit: (() -> Void)? = nil

    @State private var text: String = ""
    @State private var width: CGFloat = 0
    @FocusState private var focused: Bool

    private let size: CGFloat = 48

    var body: some View {
        HStack(spacing: 4) {
            if let prefix {
                Text(prefix)
                    .foregroundColor(.secondary)
            }
            ZStack(alignment: .trailing) {
                Text(text.isEmpty ? String(repeating: "0", count: 3) : text)
                    .font(Theme.font.body.bold())
                    .padding(.horizontal, 6)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .preference(key: WidthKey.self, value: geo.size.width)
                        }
                    )
                    .hidden()

                TextField("", text: $text, prompt: Text(placeholder))
                    .focused($focused)
                    .keyboardType(keyboardType)
                    .multilineTextAlignment(.center)
                    .frame(width: max(size, width), height: size)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(focused ? Theme.color.accent : Color.gray.opacity(0.3))
                    )
                    .onTapGesture { handleTap() }
                    .onChange(of: text) { newValue in
                        text = newValue.trimLeadingZeros()
                        syncBinding()
                    }
            }
            .onPreferenceChange(WidthKey.self) { width = $0 }

            if let suffix {
                Text(suffix)
                    .foregroundColor(.secondary)
            }
        }
        .font(Theme.font.body.bold())
        .onAppear { text = formattedValue }
        .onChange(of: focused) { if !$0 { commit() } }
    }

    private var formattedValue: String {
        guard let value else { return "" }
        if value == floor(value) {
            return String(Int(value))
        } else {
            return String(format: "%.1f", value)
        }
    }

    private func handleTap() {
        if text == "0" {
            text = ""
        }
        DispatchQueue.main.async {
            self.focused = true
            self.text = self.text
        }
    }

    private func syncBinding() {
        guard let number = Double(text), number != 0 else {
            value = nil
            return
        }
        value = number
    }

    private func commit() {
        guard let number = Double(text), number != 0 else {
            value = nil
            text = ""
            return
        }
        value = number
        onCommit?()
    }
}

private struct WidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    MetricInputField(value: .constant(12), prefix: "x", suffix: "kg")
        .padding()
}
