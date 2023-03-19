//
//  ExercisesListModel.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Combine
import Foundation

protocol ExercisesListModelProtocol {
    var exercises: AnyPublisher<[ExercisesListItem], Never> { get }
}

struct ExercisesListModel: ExercisesListModelProtocol {
    var exercises: AnyPublisher<[ExercisesListItem], Never>
    
    init(exercisesStorage: ExerciseStorage) {
        exercises = exercisesStorage.exercises.map({
            $0.compactMap({ ExercisesListItem.fromExercise($0) })
        }).eraseToAnyPublisher()
    }
}

extension ExercisesListItem {
    static func fromExercise(_ exercise: Exercise) -> ExercisesListItem? {
        return ExercisesListItem(
            id: exercise.id,
            name: exercise.name,
            oneRepMax: exercise.overallOneRepMax
        )
    }
}
