import SwiftUI

/// Editable metric field with optional label, prefix and suffix
struct MetricInputField: View {
    @Binding var value: Double?
    let metric: ExerciseMetric
    var showLabel: Bool = true

    @State private var text: String = ""
    @FocusState private var focused: Bool

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
                    .multilineTextAlignment(.trailing)
                    .onTapGesture { handleTap() }
                    .onChange(of: text) { newValue in
                        text = newValue.trimLeadingZeros()
                    }
                if metric.type != .reps {
                    Text(metric.unit?.displayName ?? "")
                        .foregroundColor(.secondary)
                }
            }
            .font(Theme.font.body.bold())
            .padding(6)
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
        }
        .onAppear { text = formattedValue }
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

    private func commit() {
        guard let number = Double(text), number != 0 else {
            value = nil
            text = ""
            return
        }
        value = number
    }
}

#Preview {
    MetricInputField(value: .constant(12), metric: ExerciseMetric(type: .reps, unit: .repetition, isRequired: true))
        .padding()
}
