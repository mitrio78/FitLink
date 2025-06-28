import SwiftUI
import AVKit
import UniformTypeIdentifiers

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
                    MarkdownTextView(text: desc)
                        .padding(.horizontal)
                }

                if viewModel.exercise.mediaURL != nil {
                    mediaView
                        .frame(maxWidth: .infinity, maxHeight: 220)
                        .padding(.horizontal)
                }

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
                        ForEach(viewModel.exercise.metrics.sorted { $0.type.sortOrder < $1.type.sortOrder }, id: \.self) { MetricBadge(metric: $0) }
                    }
                    .padding(.horizontal)
                }

                if !viewModel.exercise.muscleGroups.isEmpty {
                    Text(NSLocalizedString("ExerciseDetail.MuscleGroups", comment: "Muscles"))
                        .font(Theme.font.subheading)
                        .padding(.horizontal)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: Theme.spacing.small) {
                        let groups = [viewModel.exercise.mainMuscle] + viewModel.exercise.muscleGroups.filter { $0 != viewModel.exercise.mainMuscle }
                        ForEach(groups, id: \.self) { group in
                            MuscleGroupBadge(group: group, isMain: group == viewModel.exercise.mainMuscle)
                        }
                    }
                    .padding(.horizontal)
                }
            } //: VStack
            .padding(.vertical, Theme.spacing.medium)
        } //: ScrollView
        .background(Theme.color.background)
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
        .fullScreenCover(isPresented: $viewModel.showMediaFullScreen) {
            if let url = viewModel.exercise.mediaURL {
                FullScreenMediaView(url: url, isVideo: mediaIsVideo(url))
            }
        }
    }

    @ViewBuilder
    private var mediaView: some View {
        if let url = viewModel.exercise.mediaURL {
            if mediaIsVideo(url) {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius.image))
                    .contentShape(Rectangle())
                    .onTapGesture { viewModel.mediaTapped() }
            } else {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    default:
                        Rectangle().fill(Theme.color.backgroundSecondary)
                    }
                }
                .frame(height: 220)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: Theme.radius.image))
                .contentShape(Rectangle())
                .onTapGesture { viewModel.mediaTapped() }
            }
        }
    }

    private func mediaIsVideo(_ url: URL) -> Bool {
        if let type = UTType(filenameExtension: url.pathExtension) {
            return type.conforms(to: .movie)
        }
        return false
    }
}

#Preview {
    ExerciseDetailView(exerciseId: exercisesCatalog.first!.id)
}

