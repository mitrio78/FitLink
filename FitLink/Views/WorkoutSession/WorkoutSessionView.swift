//
//  WorkoutSessionView.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 29.05.2025.
//
import SwiftUI

struct WorkoutSessionView: View {
    let session: WorkoutSession
    let client: Client?
    
    // 1. Вынеси фильтрацию в отдельную переменную (читабельность)
    var singleExercises: [ExerciseInstance] {
        let groupedIds = Set((session.setGroups ?? []).flatMap { $0.exerciseInstanceIds })
        return session.exerciseInstances.filter { !groupedIds.contains($0.id) }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                // Заголовок
                Text("Тренировка для \(client?.name ?? "Клиента")")
                    .font(.title2.bold())
                if let date = session.date {
                    Text("\(date.formatted(date: .long, time: .shortened))")
                        .foregroundColor(.secondary)
                }
                if let notes = session.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.body)
                        .foregroundColor(.accentColor)
                        .padding(.vertical, 4)
                }
                
                // --- Блоки групп (суперсеты/дропсеты/комбо) ---
                ForEach(session.setGroups ?? []) { group in
                    WorkoutSetGroupView(
                        viewModel: WorkoutSetGroupViewModel(
                            group: group,
                            allExercises: session.exerciseInstances
                        )
                    )
                }
                
                // --- Разделитель, если хочется визуально разграничить ---
                if !singleExercises.isEmpty && (session.setGroups?.isEmpty == false) {
                    Divider().padding(.vertical, 8)
                    Text("Одиночные упражнения")
                        .font(.subheadline.bold())
                        .foregroundColor(.secondary)
                }
                
                // --- Одиночные упражнения — теперь с новым универсальным блоком ---
                ForEach(singleExercises) { exerciseInstance in
                    ExerciseBlockCard(exerciseInstance: exerciseInstance)
                        .padding(.vertical, 6)
                }
            }
            .padding()
        }
        .navigationTitle("Тренировка")
        .presentationDetents([.medium, .large])
    }
}


#Preview {
    WorkoutSessionView(session: MockData.complexMockSessions[15], client: clientsMock[0])
}
