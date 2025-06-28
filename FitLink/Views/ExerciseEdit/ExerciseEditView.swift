import SwiftUI

struct ExerciseEditView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ExerciseEditViewModel

    init(exercise: Exercise? = nil) {
        _viewModel = StateObject(wrappedValue: ExerciseEditViewModel(exercise: exercise, dataStore: .shared))
    }

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text(NSLocalizedString("ExerciseEdit.Name", comment: ""))) {
                    TextField("", text: $viewModel.name)
                }

                Section(header: Text(NSLocalizedString("ExerciseEdit.Description", comment: ""))) {
                    TextEditor(text: $viewModel.description)
                        .frame(minHeight: 100)
                }

                Section(header: Text(NSLocalizedString("ExerciseEdit.Media", comment: ""))) {
                    Button(NSLocalizedString("ExerciseEdit.MediaPlaceholder", comment: "")) {
                        // TODO: Implement media picker
                    }
                }

                Section(header: Text(NSLocalizedString("ExerciseEdit.Variations", comment: ""))) {
                    ForEach(viewModel.variations, id: \.self) { variation in
                        Text(variation)
                    }
                    .onDelete(perform: viewModel.removeVariation)

                    HStack {
                        TextField(NSLocalizedString("ExerciseEdit.VariationPlaceholder", comment: ""), text: $viewModel.newVariation)
                        Button(action: viewModel.addVariation) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }

                Section(header: Text(NSLocalizedString("ExerciseEdit.MuscleGroups", comment: ""))) {
                    ForEach(MuscleGroup.allStandardCases, id: \.self) { group in
                        HStack {
                            Text(group.displayName)
                            Spacer()
                            if viewModel.selectedGroups.contains(group) {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { viewModel.toggleGroup(group) }
                    }
                }

                Section(header: Text(NSLocalizedString("ExerciseEdit.MainMuscle", comment: ""))) {
                    Picker("", selection: Binding(get: { viewModel.mainGroup ?? viewModel.selectedGroups.first }, set: { viewModel.mainGroup = $0 })) {
                        ForEach(Array(viewModel.selectedGroups), id: \.self) { group in
                            Text(group.displayName).tag(Optional(group))
                        }
                    }
                }

                Section(header: Text(NSLocalizedString("ExerciseEdit.Metrics", comment: ""))) {
                    ForEach(viewModel.metrics.indices, id: \.self) { index in
                        let metricBinding = $viewModel.metrics[index]
                        VStack(alignment: .leading) {
                            Picker(NSLocalizedString("ExerciseEdit.MetricType", comment: ""), selection: Binding(
                                get: { metricBinding.wrappedValue.type },
                                set: { newType in
                                    metricBinding.wrappedValue.type = newType
                                    if !newType.allowedUnits.contains(metricBinding.wrappedValue.unit ?? .repetition) {
                                        metricBinding.wrappedValue.unit = newType.allowedUnits.first
                                    }
                                }
                            )) {
                                ForEach(ExerciseMetricType.allCases, id: \.self) { type in
                                    Text(type.displayName).tag(type)
                                }
                            }
                            if metricBinding.wrappedValue.type != .reps {
                                Picker(NSLocalizedString("ExerciseEdit.Unit", comment: ""), selection: Binding(
                                    get: { metricBinding.wrappedValue.unit },
                                    set: { metricBinding.wrappedValue.unit = $0 }
                                )) {
                                    Text("-").tag(UnitType?.none)
                                    ForEach(metricBinding.wrappedValue.type.allowedUnits, id: \.self) { unit in
                                        Text(unit.displayName).tag(Optional(unit))
                                    }
                                }
                            } else {
                                Text(UnitType.repetition.displayName)
                                    .font(Theme.font.caption)
                                    .foregroundColor(Theme.color.textSecondary)
                            }
                            Toggle(NSLocalizedString("ExerciseEdit.Required", comment: ""), isOn: metricBinding.isRequired)
                        }
                    }
                    .onDelete(perform: viewModel.removeMetric)
                    Button(NSLocalizedString("ExerciseEdit.AddMetric", comment: "")) {
                        viewModel.addMetric()
                    }
                }
            } //: List
            .listStyle(.insetGrouped)
            .navigationTitle(viewModel.isNew ? NSLocalizedString("ExerciseEdit.NewTitle", comment: "") : NSLocalizedString("ExerciseEdit.EditTitle", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("Common.Cancel", comment: "")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(NSLocalizedString("Common.Save", comment: "")) {
                        viewModel.save()
                        dismiss()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
        } //: NavigationStack
    }
}

#Preview {
    ExerciseEditView(exercise: exercisesCatalog.first!)
}

