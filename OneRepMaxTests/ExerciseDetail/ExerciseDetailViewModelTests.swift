//
//  ExerciseDetailViewModelTests.swift
//  OneRepMaxTests
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Combine
import Foundation
@testable import OneRepMax
import XCTest

final class ExerciseDetailViewModelTests: XCTestCase {
    private var cancellable: AnyCancellable?
    
    func testViewModel() {
        // Given
        let viewModel = ExerciseDetailViewModel(model: ExerciseDetailModelFake())

        let expectation = expectation(description: "Exercise detail view model")
        
        // When & Then
        cancellable = viewModel.$exerciseDetailItem.sink { detailItem in
            guard let item = detailItem else {
                XCTFail()
                return
            }

            XCTAssertEqual(item.exerciseListItem.name, "Back Squat")
            XCTAssertEqual(item.oneRepMaxData.count, 10)
            XCTAssertEqual(item.oneRepMaxData.first?.value, 100)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
}
