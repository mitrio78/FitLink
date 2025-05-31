import SwiftUI

struct ExerciseRow: View {
    let exercise: Exercise

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 12) {
                // Основная мышца и иконка
                Image(systemName: exercise.mainMuscle.iconName)
                    .font(.system(size: 32))
                    .foregroundColor(exercise.mainMuscle.color.opacity(0.85))
                    .frame(width: 40, height: 40)
                Text(exercise.name)
                    .font(.headline.bold())
                Spacer()
            }
            // Группы мышц (бэйджи)
            HStack(spacing: 6) {
                ForEach(exercise.muscleGroups, id: \.self) { group in
                    Text(group.displayName)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(group.color.opacity(0.18))
                        .foregroundColor(group.color)
                        .clipShape(Capsule())
                }
            }
            // Вариации (серые бейджи)
            if !exercise.variations.isEmpty {
                HStack(spacing: 6) {
                    ForEach(exercise.variations, id: \.self) { variation in
                        Text(variation)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .overlay(
                                Capsule()
                                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
        )
        .padding(.horizontal, 2)
    }
}

// Пример превью с моковыми данными
struct ExerciseRow_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRow(
            exercise: Exercise(
                id: UUID(),
                name: "Жим лёжа",
                description: "Базовое упражнение для грудных мышц.",
                mediaURL: nil,
                variations: ["Наклонная", "Узким хватом"],
                muscleGroups: [.chest, .triceps, .shoulders],
                metrics: []
            )
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
