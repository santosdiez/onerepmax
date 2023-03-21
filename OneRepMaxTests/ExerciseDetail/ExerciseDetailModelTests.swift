//
//  ExerciseDetailModelTests.swift
//  OneRepMaxTests
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Combine
import Foundation
@testable import OneRepMax
import XCTest

final class ExerciseDetailModelTests: XCTestCase {
    private var cancellable: AnyCancellable?
    
    func testLoadDetail() {
        guard let exercise = FakeData.exercises.first else {
            XCTFail()
            return
        }
        
        let expectation = expectation(description: "Load exercise detail")
        
        // Given
        let model = ExerciseDetailModel(
            exerciseStorage: StorageManager.exerciseStoragePreview,
            exerciseId: exercise.id
        )
        
        cancellable = model.detail.sink { detailItem in
            guard let item = detailItem else { return }
            
            // Then
            XCTAssertEqual(item.exerciseListItem.name, exercise.name)
            XCTAssertEqual(item.exerciseListItem.oneRepMax, exercise.overallOneRepMax)
            XCTAssertEqual(item.oneRepMaxData.count, exercise.oneRepMaxs.count)
            
            expectation.fulfill()
        }
        
        // When
        model.fetchExercise()
        
        waitForExpectations(timeout: 2.0)
    }
}
