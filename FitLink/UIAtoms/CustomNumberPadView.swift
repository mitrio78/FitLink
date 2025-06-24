import SwiftUI

/// Bottom sheet numeric keypad for editing values of one or more metrics.
struct CustomNumberPadView: View {
    let metrics: [ExerciseMetric]
    @Binding var metricValues: [ExerciseMetric.ID: Double]
    var onDone: () -> Void
    var onCancel: (() -> Void)? = nil

    @State private var input: String = ""
    @State private var selectedMetricId: ExerciseMetric.ID
    @State private var metricUnits: [ExerciseMetric.ID: UnitType]
    @State private var selectedUnit: UnitType

    init(metrics: [ExerciseMetric],
         values: Binding<[ExerciseMetric.ID: Double]>,
         onDone: @escaping () -> Void,
         onCancel: (() -> Void)? = nil) {
        let sorted = metrics.sorted { lhs, rhs in
            switch (lhs.type, rhs.type) {
            case (.reps, .reps): return false
            case (.reps, _): return true
            case (_, .reps): return false
            case (.weight, .weight): return false
            case (.weight, _): return true
            case (_, .weight): return false
            default: return lhs.type.rawValue < rhs.type.rawValue
            }
        }
        self.metrics = sorted
        self._metricValues = values
        self.onDone = onDone
        self.onCancel = onCancel

        let firstMetric = sorted.first!
        let defaultUnits = Dictionary(uniqueKeysWithValues: sorted.map { ($0.id, DraftSet.defaultUnit(for: $0)) })
        _selectedMetricId = State(initialValue: firstMetric.id)
        _metricUnits = State(initialValue: defaultUnits)
        let firstVal = values.wrappedValue[firstMetric.id] ?? 0
        _selectedUnit = State(initialValue: defaultUnits[firstMetric.id] ?? firstMetric.unit ?? .repetition)
        _input = State(initialValue: Self.formatNumber(firstVal))
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

    private var currentMetric: ExerciseMetric {
        metrics.first { $0.id == selectedMetricId } ?? metrics[0]
    }

    private var unit: UnitType { metricUnits[selectedMetricId] ?? currentMetric.unit ?? .repetition }

    private var inputLabel: String? {
        if unit == .repetition {
            return NSLocalizedString("CustomNumberPad.RepsLabel", comment: "× reps suffix")
        } else {
            let text = unit.displayName
            return text.isEmpty ? nil : text
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
        .padding(.bottom, Theme.spacing.large)
        .background(Theme.color.background)
        .cornerRadius(Theme.radius.card)
        .safeAreaInset(edge: .top) {
            Spacer().frame(height: Theme.spacing.medium)
        }
        .safeAreaInset(edge: .bottom) {
            Spacer().frame(height: Theme.spacing.large)
        }
    }

    private var topSection: some View {
        VStack(spacing: Theme.spacing.small) {
            HStack {
                Spacer()
                if let onCancel {
                    Button(action: onCancel) {
                        Image(systemName: "xmark")
                            .imageScale(.medium)
                            .padding(8)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.secondary)
                }
            } //: HStack

            Picker("", selection: $selectedMetricId) {
                ForEach(metrics, id: \.id) { metric in
                    Text(metric.displayName).tag(metric.id)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedMetricId) { oldID, newID in
                commit(to: oldID)
                selectedUnit = metricUnits[newID] ?? DraftSet.defaultUnit(for: currentMetric)
                let newValue = metricValues[newID] ?? 0
                input = Self.formatNumber(newValue)
            }

            Picker("", selection: $selectedUnit) {
                ForEach(unitOptions, id: \.self) { unit in
                    Text(unit.displayName).tag(unit)
                }
            }
           .pickerStyle(.segmented)
            .onChange(of: selectedUnit) { _, newUnit in
                metricUnits[selectedMetricId] = newUnit
            }

            Text(input.isEmpty ? "0" : input)
                .font(Theme.font.titleLarge.monospacedDigit())
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                .background(Theme.color.backgroundSecondary)
                .cornerRadius(Theme.radius.card)

            if let label = inputLabel {
                Text(label)
                    .font(Theme.font.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
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

    private func commit(to id: ExerciseMetric.ID? = nil) {
        let target = id ?? selectedMetricId
        if let val = Double(input) {
            metricValues[target] = val
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var values: [ExerciseMetric.ID: Double] = [.reps: 8, .weight: 50]
        let metrics = [ExerciseMetric(type: .reps, unit: .repetition, isRequired: true),
                       ExerciseMetric(type: .weight, unit: .kilogram, isRequired: false)]
        var body: some View {
            CustomNumberPadView(metrics: metrics, values: $values, onDone: {})
        }
    }
    return PreviewWrapper()
        .presentationDetents([.height(360)])
}


