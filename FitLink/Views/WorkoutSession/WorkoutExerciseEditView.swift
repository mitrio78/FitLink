import SwiftUI

/// Screen for adding a new exercise to a workout session or editing an existing one
struct WorkoutExerciseEditView: View {
    @ObservedObject var sessionStore: WorkoutStore
    var sessionId: UUID
    var existingExercise: ExerciseInstance? = nil

    @Environment(\.dismiss) private var dismiss

    @State private var selectedExercise: Exercise? = nil
    @State private var approaches: [Approach] = []
    @State private var showLibrary = false
    @State private var metricPickerForSet: Int? = nil

    private var isEditing: Bool { existingExercise != nil }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.spacing.large) {
                    exerciseSelectionSection
                    setsSection
                }
                .padding(Theme.spacing.medium)
            }
            .navigationTitle(isEditing ? NSLocalizedString("WorkoutExerciseEdit.EditTitle", comment: "Edit Exercise") : NSLocalizedString("WorkoutExerciseEdit.AddTitle", comment: "Add Exercise"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("Common.Cancel", comment: "Cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(NSLocalizedString("Common.Done", comment: "Done")) { save() }
                        .disabled(!canSave)
                }
            }
            .sheet(isPresented: $showLibrary) {
                ExerciseLibraryView { exercise in
                    selectedExercise = exercise
                    if approaches.isEmpty {
                        addSet()
                    }
                }
            }
            .confirmationDialog(NSLocalizedString("WorkoutExerciseEdit.SelectMetric", comment: "Select metric"), isPresented: Binding(get: { metricPickerForSet != nil }, set: { if !$0 { metricPickerForSet = nil } })) {
                if let index = metricPickerForSet, index < approaches.count {
                    let available = ExerciseMetricType.allCases.filter { approaches[index].sets.first!.metricValues[$0] == nil }
                    ForEach(available, id: \.self) { type in
                        Button(type.displayName) {
                            approaches[index].sets[0].metricValues[type] = 0
                            metricPickerForSet = nil
                        }
                    }
                }
            }
            .onAppear(perform: setup)
        }
    }

    // MARK: - Sections

    private var exerciseSelectionSection: some View {
        Group {
            if let exercise = selectedExercise {
                Button(action: { showLibrary = true }) {
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
                }
            } else {
                Button(action: { showLibrary = true }) {
                    Text("+ " + NSLocalizedString("WorkoutExerciseEdit.SelectExercise", comment: "Select Exercise"))
                        .font(Theme.font.titleMedium)
                        .frame(maxWidth: .infinity, minHeight: 120)
                        .foregroundColor(Theme.color.accent)
                        .background(Theme.color.backgroundSecondary)
                        .cornerRadius(Theme.radius.card)
                }
            }
        }
    }

    private var setsSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.medium) {
            HStack {
                Text(NSLocalizedString("WorkoutExerciseEdit.Sets", comment: "Sets"))
                    .font(Theme.font.titleSmall)
                Spacer()
                if !approaches.isEmpty {
                    Button("+" + NSLocalizedString("WorkoutExerciseEdit.AddSet", comment: "Add Set")) { addSet() }
                        .font(Theme.font.body)
                }
            }

            if approaches.isEmpty {
                Button("+" + NSLocalizedString("WorkoutExerciseEdit.AddSet", comment: "Add Set")) { addSet() }
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(Theme.color.backgroundSecondary)
                    .cornerRadius(Theme.radius.card)
            } else {
                ForEach(approaches.indices, id: \.self) { idx in
                    ExerciseSetCardView(
                        approach: $approaches[idx],
                        metrics: selectedExercise?.metrics ?? [],
                        onAddMetric: { metricPickerForSet = idx },
                        onAddPhase: { addPhase(to: idx) },
                        onDuplicate: { duplicateSet(idx) },
                        onDelete: { deleteSet(idx) }
                    )
                }
            }
        }
    }

    // MARK: - Actions

    private var canSave: Bool {
        selectedExercise != nil && !approaches.isEmpty
    }

    private func setup() {
        if let existing = existingExercise {
            selectedExercise = existing.exercise
            approaches = existing.approaches
        }
    }

    private func addSet() {
        approaches.append(
            Approach(
                sets: [ExerciseSet(id: UUID(), metricValues: [:], notes: nil, drops: nil)]
            )
        )
    }

    private func addPhase(to index: Int) {
        guard index < approaches.count else { return }
        approaches[index].sets.append(
            ExerciseSet(id: UUID(), metricValues: [:], notes: nil, drops: nil)
        )
    }

    private func duplicateSet(_ index: Int) {
        guard index < approaches.count else { return }
        let copy = approaches[index]
        approaches.insert(copy, at: index + 1)
    }

    private func deleteSet(_ index: Int) {
        guard index < approaches.count else { return }
        approaches.remove(at: index)
    }

    private func save() {
        guard let exercise = selectedExercise else { return }
        let instance = ExerciseInstance(
            id: existingExercise?.id ?? UUID(),
            exercise: exercise,
            approaches: approaches,
            groupId: existingExercise?.groupId,
            notes: existingExercise?.notes,
            section: existingExercise?.section ?? .main
        )
        if isEditing {
            sessionStore.updateExercise(instance, in: sessionId)
        } else {
            sessionStore.addExercise(instance, to: sessionId)
        }
        dismiss()
    }
}

// MARK: - Subviews

private struct ExerciseSetCardView: View {
    @Binding var approach: Approach
    let metrics: [ExerciseMetric]
    var onAddMetric: () -> Void
    var onAddPhase: () -> Void
    var onDuplicate: () -> Void
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small) {
            metricFields(for: Binding(
                get: { approach.sets.first ?? ExerciseSet(id: UUID(), metricValues: [:], notes: nil, drops: nil) },
                set: { approach.sets[0] = $0 }
            ))
            Button("+" + NSLocalizedString("WorkoutExerciseEdit.AddMetric", comment: "Add Metric"), action: onAddMetric)
                .font(Theme.font.metadata)
            if approach.sets.count > 1 {
                ForEach(approach.sets.indices.dropFirst(), id: \.self) { idx in
                    VStack(alignment: .leading) {
                        Text(String(format: NSLocalizedString("WorkoutExerciseEdit.Phase", comment: "Phase %d"), idx))
                            .font(Theme.font.metadata)
                        metricFields(for: Binding(
                            get: { approach.sets[idx] },
                            set: { approach.sets[idx] = $0 }
                        ))
                    }
                }
            }
            Button("+" + NSLocalizedString("WorkoutExerciseEdit.AddPhase", comment: "Add Phase"), action: onAddPhase)
                .font(Theme.font.metadata)
            HStack {
                Button(NSLocalizedString("WorkoutExerciseEdit.DuplicateSet", comment: "Duplicate"), action: onDuplicate)
                Spacer()
                Button(NSLocalizedString("WorkoutExerciseEdit.DeleteSet", comment: "Delete"), action: onDelete)
                    .foregroundColor(.red)
            }
            .font(Theme.font.metadata)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.color.backgroundSecondary)
        .cornerRadius(Theme.radius.card)
    }

    private func metricFields(for binding: Binding<ExerciseSet>) -> some View {
        VStack(alignment: .leading, spacing: Theme.spacing.small / 2) {
            ForEach(metrics, id: \.type) { metric in
                if binding.wrappedValue.metricValues[metric.type] != nil {
                    ExerciseMetricField(value: Binding(
                        get: { binding.wrappedValue.metricValues[metric.type] ?? 0 },
                        set: { binding.wrappedValue.metricValues[metric.type] = $0 }
                    ), metric: metric)
                }
            }
        }
    }
}

private struct ExerciseMetricField: View {
    @Binding var value: Double
    let metric: ExerciseMetric
    @State private var text: String = ""

    private var formatter: NumberFormatter {
        let f = NumberFormatter()
        f.maximumFractionDigits = 2
        return f
    }

    var body: some View {
        HStack {
            if let icon = metric.iconName {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
            }
            Text(metric.displayName)
            Spacer()
            TextField("0", value: $value, formatter: formatter)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
            if let unit = metric.unit {
                Text(unit.displayName)
                    .foregroundColor(.secondary)
            }
        }
        .font(Theme.font.body)
    }
}

#Preview {
    WorkoutExerciseEditView(sessionStore: WorkoutStore(), sessionId: MockData.complexMockSessions[0].id)
}

