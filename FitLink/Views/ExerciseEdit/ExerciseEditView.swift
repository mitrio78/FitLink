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
                        let $metric = $viewModel.metrics[index]
                        VStack(alignment: .leading) {
                            Picker(NSLocalizedString("ExerciseEdit.MetricType", comment: ""), selection: $metric.type) {
                                ForEach(ExerciseMetricType.allCases, id: \.self) { type in
                                    Text(type.displayName).tag(type)
                                }
                            }
                            Picker(NSLocalizedString("ExerciseEdit.Unit", comment: ""), selection: $metric.unit) {
                                Text("-").tag(UnitType?.none)
                                ForEach(UnitType.allCases, id: \.self) { unit in
                                    Text(unit.displayName).tag(Optional(unit))
                                }
                            }
                            Toggle(NSLocalizedString("ExerciseEdit.Required", comment: ""), isOn: $metric.isRequired)
                        }
                    }
                    .onDelete(perform: viewModel.removeMetric)
                    Button(NSLocalizedString("ExerciseEdit.AddMetric", comment: "")) {
                        viewModel.addMetric()
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(viewModel.isNew ? NSLocalizedString("ExerciseEdit.NewTitle", comment: "") : NSLocalizedString("ExerciseEdit.EditTitle", comment: ""))
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
        }
    }
}

#Preview {
    ExerciseEditView(exercise: exercisesCatalog.first!)
}

