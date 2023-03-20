//
//  ExerciseStorage.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Combine
import Foundation

protocol ExerciseStorage {
    var exercises: CurrentValueSubject<[Exercise], Never> { get }
    var exerciseDetail: CurrentValueSubject<Exercise?, Never> { get }
    
    func fetchExercise(by id: UUID) throws
    func add(exercises: [Exercise]) throws
    func deleteAll() throws
}

// Helper extension for testing/previews
extension ExerciseStorage {
    var firstExercise: Exercise? {
        exercises.value.first
    }
}
