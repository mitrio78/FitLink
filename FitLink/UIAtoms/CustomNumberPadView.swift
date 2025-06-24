import SwiftUI

/// Bottom sheet numeric keypad for editing metric values.
struct CustomNumberPadView: View {
    @Binding var value: Double
    var unit: UnitType
    var onDone: () -> Void
    var onCancel: (() -> Void)? = nil

    @State private var input: String = ""
    @State private var selectedUnit: UnitType

    init(value: Binding<Double>, unit: UnitType, onDone: @escaping () -> Void, onCancel: (() -> Void)? = nil) {
        self._value = value
        self.unit = unit
        self.onDone = onDone
        self.onCancel = onCancel
        _selectedUnit = State(initialValue: unit)
        _input = State(initialValue: Self.formatNumber(value.wrappedValue))
    }

    private static func formatNumber(_ val: Double) -> String {
        if val == floor(val) {
            return String(Int(val))
        } else {
            var str = String(format: "%.2f", val)
            while str.contains(".") && str.last == "0" { str.removeLast() }
            if str.last == "." { str.removeLast() }
            return str
        }
    }

    private var metricName: String {
        switch unit {
        case .kilogram, .pound:
            return NSLocalizedString("ExerciseMetricType.Weight", comment: "Вес")
        case .second, .minute:
            return NSLocalizedString("ExerciseMetricType.Time", comment: "Время")
        case .meter, .kilometer:
            return NSLocalizedString("ExerciseMetricType.Distance", comment: "Дистанция")
        case .repetition:
            return NSLocalizedString("ExerciseMetricType.Reps", comment: "Повторы")
        case .calorie:
            return NSLocalizedString("ExerciseMetricType.Calories", comment: "Калории")
        case .custom(let name):
            return name
        }
    }

    private var unitOptions: [UnitType] {
        switch unit {
        case .kilogram, .pound:
            return [.kilogram, .pound]
        case .second, .minute:
            return [.second, .minute]
        case .meter, .kilometer:
            return [.meter, .kilometer]
        case .repetition:
            return [.repetition]
        case .calorie:
            return [.calorie]
        case .custom:
            return [unit]
        }
    }

    private var isValid: Bool {
        Double(input) != nil
    }

    var body: some View {
        VStack(spacing: Theme.spacing.large) {
            topSection
            numberPad
            Button(NSLocalizedString("Common.Done", comment: "Done")) {
                commit()
                onDone()
            }
            .disabled(!isValid)
            .font(Theme.font.titleSmall)
            .frame(maxWidth: .infinity)
            .padding()
            .background(isValid ? Theme.color.accent : Theme.color.accent.opacity(0.3))
            .foregroundColor(.white)
            .cornerRadius(Theme.radius.button)
        } //: VStack
        .padding(.horizontal, Theme.spacing.large)
        .padding(.top, Theme.spacing.large)
        .padding(.bottom, Theme.spacing.large)
        .background(Theme.color.background)
        .cornerRadius(Theme.radius.card)
        .safeAreaInset(edge: .bottom) {
            Spacer().frame(height: Theme.spacing.large)
        }
    }

    private var topSection: some View {
        VStack(spacing: Theme.spacing.small) {
            HStack {
                Text(metricName)
                    .font(Theme.font.subheading)
                Spacer()
                if let onCancel {
                    Button(action: onCancel) {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            } //: HStack
            Picker("", selection: $selectedUnit) {
                ForEach(unitOptions, id: \.self) { unit in
                    Text(unit.displayName).tag(unit)
                }
            }
            .pickerStyle(.segmented)

            Text(input.isEmpty ? "0" : input)
                .font(Theme.font.titleLarge.monospacedDigit())
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                .background(Theme.color.backgroundSecondary)
                .cornerRadius(Theme.radius.card)
        } //: VStack
    }

    private var numberPad: some View {
        VStack(spacing: Theme.spacing.medium) {
            ForEach(keys, id: \.self) { row in
                HStack(spacing: Theme.spacing.medium) {
                    ForEach(row, id: \.self) { key in
                        Button(action: { handleKey(key) }) {
                            Text(key)
                                .font(Theme.font.titleMedium)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .foregroundColor(.primary)
                                .background(Theme.color.backgroundSecondary)
                                .cornerRadius(Theme.radius.button)
                        }
                        .buttonStyle(.plain)
                    }
                } //: HStack
            }
        } //: VStack
    }

    private var keys: [[String]] { [["1","2","3"],["4","5","6"],["7","8","9"],[".","0","⌫"]] }

    private func handleKey(_ key: String) {
        switch key {
        case "⌫":
            if !input.isEmpty { input.removeLast() }
        case ".":
            if !input.contains(".") {
                input.append(input.isEmpty ? "0." : ".")
            }
        default:
            if input == "0" {
                input = key
            } else {
                input.append(key)
            }
        }
    }

    private func commit() {
        if let val = Double(input) {
            value = val
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var value: Double = 75
        var body: some View {
            CustomNumberPadView(value: $value, unit: .kilogram, onDone: {})
        }
    }
    return PreviewWrapper()
        .presentationDetents([.height(360)])
}

