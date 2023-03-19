//
//  ExerciseDetailModel.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Combine
import Foundation

protocol ExerciseDetailModelProtocol {
    var detail: AnyPublisher<ExerciseDetailItem?, Never> { get }
    
    func fetchExercise()
}

class ExerciseDetailModel: ExerciseDetailModelProtocol {
    var detail: AnyPublisher<ExerciseDetailItem?, Never>
    private let exerciseStorage: ExerciseStorage
    private let exerciseId: UUID
    
    init(exerciseStorage: ExerciseStorage = StorageManager.exerciseStorage, exerciseId: UUID) {
        self.exerciseStorage = exerciseStorage
        self.exerciseId = exerciseId
        detail = exerciseStorage.exerciseDetail.map({
            ExerciseDetailItem.fromExercise($0)
        }).eraseToAnyPublisher()
    }
    
    func fetchExercise() {
        do {
            try exerciseStorage.fetchExercise(by: exerciseId)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ExerciseDetailItem {
    static func fromExercise(_ exercise: Exercise?) -> ExerciseDetailItem? {
        guard let exercise = exercise,
              let listItem = ExercisesListItem.fromExercise(exercise) else { return nil }
        
        return ExerciseDetailItem(
            exerciseListItem: listItem,
            oneRepMaxData: exercise.oneRepMaxs.map { OneRepMaxItem(date: $0.date, value: $0.oneRepMax) }
        )
    }
}
