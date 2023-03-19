//
//  ExerciseListModelTests.swift
//  OneRepMaxTests
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Combine
import Foundation
@testable import OneRepMax
import XCTest

final class ExercisesListModelTests: XCTestCase {
    private var cancellable: AnyCancellable?
    
    func testLoadExercises() {
        // Given
        let model = ExercisesListModel(exercisesStorage: StorageManager.exerciseStoragePreview)
        
        let expectation = expectation(description: "Loading exercises")
        
        // When
        cancellable = model.exercises.sink { exercises in
            XCTAssertEqual(exercises.count, 2)
            
            let name = "Back Squat"
            let firstExercise = exercises.first // Sorted alphabetically
            
            // Then
            XCTAssertEqual(firstExercise?.name, name)
            XCTAssertEqual(firstExercise?.oneRepMax, Decimal(name.count))
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
}
