import SwiftUI

/// Reusable numeric input component with optional prefix/suffix and presets.
struct MetricInputField: View {
    @Binding var value: String
    var labelPrefix: String? = nil
    var labelSuffix: String? = nil
    var placeholder: String? = nil
    var keyboardType: UIKeyboardType = .decimalPad
    var accentColor: Color = Theme.color.accent
    var presets: [Double] = []
    var scrollProxy: ScrollViewProxy? = nil
    var scrollId: AnyHashable = UUID()
    var onCommit: () -> Void = {}

    @State private var width: CGFloat = 0
    @FocusState private var focused: Bool

    private let size: CGFloat = 48

    var body: some View {
        VStack(spacing: Theme.spacing.small) {
            HStack(spacing: 4) {
                if let labelPrefix {
                    Text(labelPrefix)
                        .foregroundColor(.secondary)
                }
                ZStack(alignment: .trailing) {
                    Text(value.isEmpty ? String(repeating: "0", count: 3) : value)
                        .font(Theme.font.body.bold())
                        .padding(.horizontal, 6)
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(key: WidthKey.self, value: geo.size.width)
                            }
                        )
                        .hidden()

                    TextField("", text: $value, prompt: placeholder.map { Text($0) })
                        .focused($focused)
                        .keyboardType(keyboardType)
                        .multilineTextAlignment(.center)
                        .frame(width: max(size, width), height: size)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.radius.button)
                                .stroke(focused ? accentColor : Theme.color.border)
                                .background(
                                    RoundedRectangle(cornerRadius: Theme.radius.button)
                                        .fill(focused ? Theme.color.backgroundSecondary : Color.clear)
                                )
                        )
                        .onTapGesture(count: 1) { handleTap() }
                        .onTapGesture(count: 2) { reset() }
                        .onChange(of: value) { _, newVal in
                            value = newVal.trimLeadingZeros()
                        }
                }
                .onPreferenceChange(WidthKey.self) { width = $0 }

                if let labelSuffix {
                    Text(labelSuffix)
                        .foregroundColor(.secondary)
                }
            } //: HStack
            if focused && !presets.isEmpty {
                HStack(spacing: Theme.spacing.small) {
                    ForEach(presets, id: \.self) { preset in
                        Button("+\(formattedPreset(preset))") {
                            addPreset(preset)
                        }
                        .buttonStyle(.plain)
                        .font(Theme.font.body)
                        .padding(.vertical, Theme.spacing.small / 2)
                        .padding(.horizontal, Theme.spacing.small)
                        .background(Theme.color.backgroundSecondary)
                        .cornerRadius(Theme.radius.button)
                    }
                }
            }
        } //: VStack
        .id(scrollId)
        .font(Theme.font.body.bold())
        .onAppear { value = value.trimLeadingZeros() }
        .onChange(of: focused) { _, isFocused in
            if isFocused {
                scrollToSelf()
            } else {
                commit()
            }
        }
        .animation(.easeInOut(duration: 0.2), value: focused)
    }

    private func handleTap() {
        DispatchQueue.main.async {
            self.focused = true
            self.value = self.value
        }
    }

    private func reset() {
        value = ""
    }

    private func addPreset(_ preset: Double) {
        let current = Double(value) ?? 0
        let newVal = current + preset
        value = formatValue(newVal)
    }

    private func commit() {
        value = value.trimLeadingZeros()
        if value == "0" { value = "" }
        if !value.isEmpty {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        onCommit()
    }

    private func formattedPreset(_ preset: Double) -> String {
        formatValue(preset)
    }

    private func formatValue(_ val: Double) -> String {
        if val == floor(val) {
            return String(Int(val))
        } else {
            return String(format: "%.1f", val)
        }
    }

    private func scrollToSelf() {
        withAnimation {
            scrollProxy?.scrollTo(scrollId, anchor: .bottom)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            withAnimation {
                scrollProxy?.scrollTo(scrollId, anchor: .bottom)
            }
        }
    }
}

private struct WidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    MetricInputField(value: .constant("75"), labelPrefix: "×", labelSuffix: "kg", presets: [2.5,5,10])
        .padding()
}
