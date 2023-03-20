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
        guard let exerciseId = StorageManager.exerciseStoragePreview.firstExercise?.id else {
            XCTFail()
            return
        }
        
        let expectation = expectation(description: "Load exercise detail")
        
        // Given
        let model = ExerciseDetailModel(
            exerciseStorage: StorageManager.exerciseStoragePreview,
            exerciseId: exerciseId
        )
        
        cancellable = model.detail.sink { detailItem in
            guard let item = detailItem else { return }
            
            // Then
            XCTAssertEqual(item.exerciseListItem.name, "Back Squat")
            XCTAssertEqual(item.exerciseListItem.oneRepMax, 100)
            XCTAssertEqual(item.oneRepMaxData.count, 10)
            
            expectation.fulfill()
        }
        
        // When
        model.fetchExercise()
        
        waitForExpectations(timeout: 2.0)
    }
}
