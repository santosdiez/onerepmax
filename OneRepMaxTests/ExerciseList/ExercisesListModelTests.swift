//
//  ExercisesListModelTests.swift
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
            
            let firstExercise = exercises.first // Sorted alphabetically
            
            // Then
            XCTAssertEqual(firstExercise?.name, "Back Squat")
            XCTAssertEqual(firstExercise?.oneRepMax, 100)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
}
