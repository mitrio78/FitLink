import SwiftUI

/// Screen for selecting one or multiple exercises
struct WorkoutExerciseEditView: View {
    var onComplete: (WorkoutExerciseEditResult) -> Void

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: WorkoutExerciseEditViewModel
    private let isEditing: Bool
    @State private var libraryIndex: Int = 0
    @State private var showLibrary = false

    init(initialExercises: [Exercise] = [], onComplete: @escaping (WorkoutExerciseEditResult) -> Void) {
        self.onComplete = onComplete
        _viewModel = StateObject(wrappedValue: WorkoutExerciseEditViewModel(initialExercises: initialExercises))
        self.isEditing = !initialExercises.isEmpty
    }

    var body: some View {
        NavigationStack {
            List {
                exercisesList
            }
            .listStyle(.plain)
            .animation(.default, value: viewModel.selectedExercises)
            .padding(Theme.spacing.medium)
            .navigationTitle(isEditing ? NSLocalizedString("WorkoutExerciseEdit.EditTitle", comment: "Edit Exercise") : NSLocalizedString("WorkoutExerciseEdit.AddTitle", comment: "Add Exercise"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("Common.Cancel", comment: "Cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(NSLocalizedString("Common.Done", comment: "Done")) {
                        if let result = viewModel.confirmSelection() {
                            onComplete(result)
                        }
                        dismiss()
                    }
                    .disabled(viewModel.selectedExercises.isEmpty)
                }
            }
            .sheet(isPresented: $showLibrary) {
                ExerciseLibraryView { exercise in
                    if libraryIndex < viewModel.selectedExercises.count {
                        viewModel.replaceExercise(at: libraryIndex, with: exercise)
                    } else {
                        viewModel.addExercise(exercise)
                    }
                    showLibrary = false
                }
            }
        }
    }

    @ViewBuilder
    private var exercisesList: some View {
        if viewModel.selectedExercises.isEmpty {
            Button(action: { libraryIndex = 0; showLibrary = true }) {
                Text("+ " + NSLocalizedString("WorkoutExerciseEdit.SelectExercise", comment: "Select Exercise"))
                    .font(Theme.font.titleMedium)
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .foregroundColor(Theme.color.accent)
                    .background(Theme.color.backgroundSecondary)
                    .cornerRadius(Theme.radius.card)
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        } else {
            ForEach(Array(viewModel.selectedExercises.enumerated()), id: \.offset) { idx, exercise in
                exerciseRow(for: exercise, index: idx)
            }
            Button(action: { libraryIndex = viewModel.selectedExercises.count; showLibrary = true }) {
                Text("+ " + NSLocalizedString("WorkoutExerciseEdit.AddAnotherExercise", comment: "Add Another Exercise"))
                    .font(Theme.font.body)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .foregroundColor(Theme.color.accent)
                    .background(Theme.color.backgroundSecondary)
                    .cornerRadius(Theme.radius.card)
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
    }

    @ViewBuilder
    private func exerciseRow(for exercise: Exercise, index: Int) -> some View {
        Button(action: { libraryIndex = index; showLibrary = true }) {
            HStack {
                Image(systemName: exercise.mainMuscle.iconName)
                    .font(.largeTitle)
                    .foregroundColor(exercise.mainMuscle.color)
                Text(exercise.name)
                    .font(Theme.font.titleMedium.bold())
                Spacer()
                Text(NSLocalizedString("WorkoutExerciseEdit.Change", comment: "Replace"))
                    .font(Theme.font.body)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.color.backgroundSecondary)
            .cornerRadius(Theme.radius.card)
            .padding(.bottom)
        }
        .contentShape(Rectangle())
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                if viewModel.removeExercise(at: index) && isEditing {
                    onComplete(.deleted)
                    dismiss()
                }
            } label: {
                Label(NSLocalizedString("Common.Delete", comment: "Delete"), systemImage: "trash")
            }
        }
    }
}

#Preview {
    WorkoutExerciseEditView { _ in }
}
