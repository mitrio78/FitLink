import SwiftUI

/// Bottom sheet numeric keypad for editing values of one or more metrics.
struct CustomNumberPadView: View {
    @Binding var metricValues: [ExerciseMetric.ID: Double]
    var onDone: () -> Void

    @StateObject private var viewModel: CustomNumberPadViewModel
    
    init(
        metrics: [ExerciseMetric],
        values: Binding<[ExerciseMetric.ID: Double]>,
        onDone: @escaping () -> Void
    ) {
        self._metricValues = values
        self.onDone = onDone
        _viewModel = StateObject(wrappedValue: CustomNumberPadViewModel(metrics: metrics, values: values.wrappedValue))
    }

    private var metricSelection: Binding<ExerciseMetric.ID> {
        Binding(
            get: { viewModel.selectedMetricId },
            set: { newID in
                commit()
                viewModel.updateSelection(to: newID, values: metricValues)
            }
        )
    }

    var body: some View {
        VStack(spacing: Theme.spacing.small / 2) {
            topSection
            numberPad
            Button(NSLocalizedString("Common.Done", comment: "Done")) {
                commit()
                onDone()
            }
            .disabled(!viewModel.isValid)
            .font(Theme.font.titleSmall)
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.isValid ? Theme.color.accent : Theme.color.accent.opacity(0.3))
            .foregroundColor(.white)
            .cornerRadius(Theme.radius.button)
        } //: VStack
        .padding(.horizontal, Theme.spacing.small)
        .padding(.top, Theme.spacing.small)
        .padding(.bottom, Theme.spacing.sheetBottomPadding)
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
            Picker("", selection: metricSelection) {
                ForEach(viewModel.metrics, id: \.id) { metric in
                    Text(metric.displayName).tag(metric.id)
                }
            }
            .pickerStyle(.segmented)

            Text(viewModel.input.isEmpty ? "0" : viewModel.input + " \(viewModel.inputLabel ?? "")")
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
                                .frame(height: Theme.size.numberPadButtonHeight)
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
            if !viewModel.input.isEmpty { viewModel.input.removeLast() }
        case ".":
            if !viewModel.input.contains(".") {
                viewModel.input.append(viewModel.input.isEmpty ? "0." : ".")
            }
        default:
            if viewModel.input == "0" {
                viewModel.input = key
            } else {
                viewModel.input.append(key)
            }
        }
    }

    private func commit(to id: ExerciseMetric.ID? = nil) {
        let target = id ?? viewModel.selectedMetricId
        if let val = Double(viewModel.input) {
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


