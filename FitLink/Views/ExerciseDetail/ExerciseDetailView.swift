import SwiftUI

struct ExerciseDetailView: View {
    @StateObject private var viewModel: ExerciseDetailViewModel

    init(exerciseId: UUID) {
        _viewModel = StateObject(wrappedValue: ExerciseDetailViewModel(exerciseId: exerciseId, dataStore: .shared))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.spacing.medium) {
                Text(viewModel.exercise.name)
                    .font(Theme.font.titleMedium.bold())
                    .padding(.horizontal)

                if let desc = viewModel.exercise.description, !desc.isEmpty {
                    Text(desc)
                        .font(Theme.font.body)
                        .padding(.horizontal)
                }

                mediaView
                    .frame(maxWidth: .infinity, maxHeight: 220)
                    .padding(.horizontal)

                if !viewModel.exercise.variations.isEmpty {
                    Text(NSLocalizedString("ExerciseDetail.Variations", comment: "Variations"))
                        .font(Theme.font.subheading)
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.spacing.small) {
                            ForEach(viewModel.exercise.variations, id: \.self) { VariationBadge(variation: $0) }
                        }
                        .padding(.horizontal)
                    }
                }

                if !viewModel.exercise.metrics.isEmpty {
                    Text(NSLocalizedString("ExerciseDetail.Metrics", comment: "Metrics"))
                        .font(Theme.font.subheading)
                        .padding(.horizontal)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: Theme.spacing.small) {
                        ForEach(viewModel.exercise.metrics, id: \.self) { MetricBadge(metric: $0) }
                    }
                    .padding(.horizontal)
                }

                if !viewModel.exercise.muscleGroups.isEmpty {
                    Text(NSLocalizedString("ExerciseDetail.MuscleGroups", comment: "Muscles"))
                        .font(Theme.font.subheading)
                        .padding(.horizontal)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: Theme.spacing.small) {
                        ForEach(viewModel.exercise.muscleGroups, id: \.self) { group in
                            MuscleGroupBadge(group: group, isMain: group == viewModel.exercise.mainMuscle)
                        }
                    }
                    .padding(.horizontal)
                }
            } //: VStack
            .padding(.vertical, Theme.spacing.medium)
        }
        .background(Theme.color.background)
        .navigationTitle(viewModel.exercise.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(NSLocalizedString("ExerciseDetail.Edit", comment: "Edit")) {
                    viewModel.editTapped()
                }
            }
        }
        .sheet(isPresented: $viewModel.showEdit) {
            ExerciseEditView(exercise: viewModel.exercise)
        }
    }

    @ViewBuilder
    private var mediaView: some View {
        if let url = viewModel.exercise.mediaURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill().clipped()
                default:
                    Rectangle().fill(Theme.color.backgroundSecondary)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius.image))
        } else {
            Rectangle()
                .fill(Theme.color.backgroundSecondary)
                .overlay(Image(systemName: "photo"))
                .clipShape(RoundedRectangle(cornerRadius: Theme.radius.image))
        }
    }
}

#Preview {
    ExerciseDetailView(exerciseId: exercisesCatalog.first!.id)
}

