import SwiftUI
import PhotosUI
import AVKit

struct ExerciseEditView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ExerciseEditViewModel
    @State private var pickerItem: PhotosPickerItem? = nil

    init(exercise: Exercise? = nil) {
        _viewModel = StateObject(wrappedValue: ExerciseEditViewModel(exercise: exercise, dataStore: .shared))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                formList
                    .listStyle(.insetGrouped)

                if viewModel.isProcessingMedia {
                    ProgressView()
                }
            } //: ZStack
            .navigationTitle(viewModel.isNew ? NSLocalizedString("ExerciseEdit.NewTitle", comment: "") : NSLocalizedString("ExerciseEdit.EditTitle", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("Common.Cancel", comment: "")) {
                        viewModel.cancel()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(NSLocalizedString("Common.Save", comment: "")) {
                        viewModel.save()
                        dismiss()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
            .onChange(of: pickerItem) { _, newValue in
                guard let item = newValue else { return }
                Task {
                    if let url = try? await item.loadTransferable(type: URL.self) {
                        viewModel.onMediaSelected(tempURL: url)
                    }
                    pickerItem = nil
                }
            }
            .alert(viewModel.errorMessage ?? "", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )) {
                Button("OK", role: .cancel) { }
            }
        } //: NavigationStack
    }

    private var formList: some View {
        List {
            nameSection
            descriptionSection
            mediaSection
            variationsSection
            groupsSection
            mainMuscleSection
            metricsSection
        } //: List
    }

    @ViewBuilder private var nameSection: some View {
        Section {
            TextField("", text: $viewModel.name)
        } header: {
            Text(NSLocalizedString("ExerciseEdit.Name", comment: ""))
        }
    }

    @ViewBuilder private var descriptionSection: some View {
        Section {
            TextEditor(text: $viewModel.description)
                .frame(minHeight: 100)
        } header: {
            Text(NSLocalizedString("ExerciseEdit.Description", comment: ""))
        }
    }

    @ViewBuilder private var mediaSection: some View {
        Section {
            Group {
                if let url = viewModel.mediaURL {
                    mediaPreview(url)
                    HStack {
                        PhotosPicker(selection: $pickerItem, matching: [.images, .videos]) {
                            Text(NSLocalizedString("ExerciseEdit.ReplaceMedia", comment: ""))
                        }
                        Spacer()
                        Button(role: .destructive) {
                            viewModel.removeMedia()
                        } label: {
                            Text(NSLocalizedString("ExerciseEdit.RemoveMedia", comment: ""))
                        }
                    }
                } else {
                    PhotosPicker(selection: $pickerItem, matching: [.images, .videos]) {
                        Text(NSLocalizedString("ExerciseEdit.MediaPlaceholder", comment: ""))
                    }
                }
            }
        } header: {
            Text(NSLocalizedString("ExerciseEdit.Media", comment: ""))
        }
    }

    @ViewBuilder private var variationsSection: some View {
        Section {
            Group {
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
        } header: {
            Text(NSLocalizedString("ExerciseEdit.Variations", comment: ""))
        }
    }

    @ViewBuilder private var groupsSection: some View {
        Section {
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
        } header: {
            Text(NSLocalizedString("ExerciseEdit.MuscleGroups", comment: ""))
        }
    }

    @ViewBuilder private var mainMuscleSection: some View {
        let selection = Binding<MuscleGroup?>(
            get: { viewModel.mainGroup ?? viewModel.selectedGroups.first },
            set: { viewModel.mainGroup = $0 }
        )
        Section {
            Picker("", selection: selection) {
                ForEach(Array(viewModel.selectedGroups), id: \.self) { group in
                    Text(group.displayName).tag(Optional(group))
                }
            }
        } header: {
            Text(NSLocalizedString("ExerciseEdit.MainMuscle", comment: ""))
        }
    }

    @ViewBuilder private var metricsSection: some View {
        Section {
            Group {
                ForEach(viewModel.metrics.indices, id: \.self) { index in
                    MetricRow(metric: $viewModel.metrics[index])
                }
                .onDelete(perform: viewModel.removeMetric)
                Button(NSLocalizedString("ExerciseEdit.AddMetric", comment: "")) {
                    viewModel.addMetric()
                }
            }
        } header: {
            Text(NSLocalizedString("ExerciseEdit.Metrics", comment: ""))
        }
    }

    @ViewBuilder
    private func mediaPreview(_ url: URL) -> some View {
        if viewModel.mediaIsVideo(url) {
            VideoPlayer(player: AVPlayer(url: url))
                .frame(height: 200)
        } else {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Rectangle().fill(Theme.color.backgroundSecondary)
                }
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius.image))
        }
    }

    private struct MetricRow: View {
        @Binding var metric: ExerciseMetric

        var body: some View {
            VStack(alignment: .leading) {
                metricTypePicker
                unitPicker
                Toggle(NSLocalizedString("ExerciseEdit.Required", comment: ""), isOn: $metric.isRequired)
            } //: VStack
        }

        private var metricTypePicker: some View {
            Picker(NSLocalizedString("ExerciseEdit.MetricType", comment: ""), selection: $metric.type) {
                ForEach(ExerciseMetricType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .onChange(of: metric.type) { _, newType in
                if !newType.allowedUnits.contains(metric.unit ?? .repetition) {
                    metric.unit = newType.allowedUnits.first
                }
            }
        }

        @ViewBuilder private var unitPicker: some View {
            if metric.type != .reps {
                Picker(NSLocalizedString("ExerciseEdit.Unit", comment: ""), selection: $metric.unit) {
                    Text("-").tag(UnitType?.none)
                    ForEach(metric.type.allowedUnits, id: \.self) { unit in
                        Text(unit.displayName).tag(Optional(unit))
                    }
                }
            } else {
                Text(UnitType.repetition.displayName)
                    .font(Theme.font.caption)
                    .foregroundColor(Theme.color.textSecondary)
            }
        }
    }

}

#Preview {
    ExerciseEditView(exercise: exercisesCatalog.first!)
}

