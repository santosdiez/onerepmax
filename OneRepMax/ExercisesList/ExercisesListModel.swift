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

struct ExerciseListModel: ExerciseListModelProtocol {
    var exercises: AnyPublisher<[ExerciseListItem], Never>
    
    init(exercisesStorage: ExerciseStorage) {
        exercises = exercisesStorage.exercises.map({
            $0.compactMap({ ExerciseListItem.fromExercise($0) })
        }).eraseToAnyPublisher()
    }
}

extension ExerciseListItem {
    static func fromExercise(_ exercise: Exercise) -> ExerciseListItem? {
        return ExerciseListItem(
            id: exercise.id,
            name: exercise.name,
            oneRepMax: exercise.overallOneRepMax
        )
    }
}
