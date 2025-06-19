import SwiftUI

/// Editable metric field with optional label, prefix and suffix
struct MetricInputField: View {
    @Binding var value: Double?
    let metric: ExerciseMetric
    var showLabel: Bool = true

    @State private var text: String = ""
    @FocusState private var focused: Bool
    var onCommit: (() -> Void)? = nil

    var body: some View {
        HStack {
            if showLabel {
                Text(metric.displayName)
                Spacer()
            }
            HStack(spacing: 4) {
                if metric.type == .reps {
                    Text("x")
                        .foregroundColor(.secondary)
                }
                TextField("0", text: $text)
                    .focused($focused)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: 48, minHeight: 48)
                    .padding(.horizontal, 4)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(focused ? Theme.color.accent : Color.gray.opacity(0.3)))
                    .onTapGesture { handleTap() }
                    .onChange(of: text) { newValue in
                        text = newValue.trimLeadingZeros()
                        syncBinding()
                    }
                if metric.type != .reps {
                    Text(metric.unit?.displayName ?? "")
                        .foregroundColor(.secondary)
                }
            }
            .font(Theme.font.body.bold())
        }
        .onAppear {
            text = formattedValue
        }
        .onChange(of: focused) { newValue in
            if !newValue { commit() }
        }
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
        DispatchQueue.main.async { self.focused = true }
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

#Preview {
    MetricInputField(value: .constant(12), metric: ExerciseMetric(type: .reps, unit: .repetition, isRequired: true))
        .padding()
}
