//
//  ExercisesListModel.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Combine
import Foundation

protocol ExerciseListModelProtocol {
    var exercises: AnyPublisher<[ExerciseListItem], Never> { get }
}

struct ExerciseListModel<Storage>: ExerciseListModelProtocol where Storage: ExerciseStorage {
    var exercises: AnyPublisher<[ExerciseListItem], Never>
    
    init(exercisesStorage: Storage) {
        exercises = exercisesStorage.exercises.map({
            $0.compactMap({ ExerciseListItem.fromExercise($0) })
        }).eraseToAnyPublisher()
    }
}

private extension ExerciseListItem {
    static func fromExercise(_ exercise: Exercise) -> ExerciseListItem? {
        guard let id = exercise.id else { return nil }
        
        return ExerciseListItem(
            id: id,
            name: exercise.name,
            oneRepMax: exercise.overallOneRepMax
        )
    }
}
