import SwiftUI

/// Bottom sheet numeric keypad for editing values of one or more metrics.
struct CustomNumberPadView: View {
    let metrics: [ExerciseMetric]
    @Binding var metricValues: [ExerciseMetric.ID: Double]
    var onDone: () -> Void

    @State private var input: String = ""
    @State private var selectedMetricId: ExerciseMetric.ID
    @State private var metricUnits: [ExerciseMetric.ID: UnitType]
    @State private var selectedUnit: UnitType
    
    init(
        metrics: [ExerciseMetric],
        values: Binding<[ExerciseMetric.ID: Double]>,
        onDone: @escaping () -> Void
    ) {
        let sorted = metrics.sorted { (lhs: ExerciseMetric, rhs: ExerciseMetric) in
            lhs.type.sortIndex < rhs.type.sortIndex
        }
        self.metrics = sorted
        self._metricValues = values
        self.onDone = onDone

        let firstMetric = sorted.first!
        let defaultUnits: [ExerciseMetric.ID: UnitType] =
            Dictionary(uniqueKeysWithValues: sorted.map { ($0.id, DraftSet.defaultUnit(for: $0)) })
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

    private func metric(for id: ExerciseMetric.ID) -> ExerciseMetric {
        metrics.first { $0.id == id } ?? metrics[0]
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

    private var metricSelection: Binding<ExerciseMetric.ID> {
        Binding(
            get: { selectedMetricId },
            set: { newID in
                commit()
                selectedMetricId = newID
                let metric = metric(for: newID)
                selectedUnit = metricUnits[newID] ?? DraftSet.defaultUnit(for: metric)
                let newValue = metricValues[newID] ?? 0
                input = Self.formatNumber(newValue)
            }
        )
    }

    private var isValid: Bool {
        Double(input) != nil
    }

    var body: some View {
        VStack(spacing: Theme.spacing.small) {
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
        .padding(.horizontal, Theme.spacing.small)
        .padding(.top, 4)
        .padding(.bottom, 4)
        .background(Theme.color.background)
        .cornerRadius(Theme.radius.card)
//        .safeAreaInset(edge: .top) {
//            Spacer().frame(height: Theme.spacing.small)
//        }
//        .safeAreaInset(edge: .bottom) {
//            Spacer().frame(height: Theme.spacing.small)
//        }
    }

    private var topSection: some View {
        VStack(spacing: Theme.spacing.small) {
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.secondary.opacity(0.4))
                    .frame(width: 40, height: 4)
                Spacer()
            } //: HStack
            .padding(.top, 4)
            .padding(.bottom, 2)
 
            Picker("", selection: metricSelection) {
                ForEach(metrics, id: \.id) { metric in
                    Text(metric.displayName).tag(metric.id)
                }
            }
            .pickerStyle(.segmented)
            
            Text(input.isEmpty ? "0" : input + " \(inputLabel ?? "")")
                .font(Theme.font.titleLarge.monospacedDigit())
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(Theme.spacing.medium)
                .background(Theme.color.backgroundSecondary)
                .cornerRadius(Theme.radius.card)
        } //: VStack
    }

    private var numberPad: some View {
        VStack(spacing: Theme.spacing.small) {
            ForEach(keys, id: \.self) { row in
                HStack(spacing: Theme.spacing.small) {
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


