//
//  ExercisesListViewModelTests.swift
//  OneRepMaxTests
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Combine
import Foundation
import XCTest
@testable import OneRepMax

final class ExercisesListViewModelTests: XCTestCase {
    private var cancellable: AnyCancellable?
    
    func testViewModel() {
        // Given
        let viewModel = ExercisesListViewModel(model: ExercisesListModelFake())
        
        let expectation = expectation(description: "Exercises list view model")
        
        // When
        cancellable = viewModel.$exercises.sink { exercises in
            // Then
            let firstItem = exercises.first
            XCTAssertEqual(firstItem?.name, "Back Squat")
            XCTAssertEqual(firstItem?.oneRepMax, 100)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
}
