//
//  ExerciseListModelFake.swift
//  OneRepMaxTests
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Combine
import Foundation
@testable import OneRepMax

struct ExercisesListModelFake: ExercisesListModelProtocol {
    var exercises: AnyPublisher<[ExercisesListItem], Never>
    
    private let fakeItem = ExercisesListItem(
        id: UUID(),
        name: "Back Squat",
        oneRepMax: 100
    )
    
    init() {
        exercises = [[fakeItem]].publisher.eraseToAnyPublisher()
    }
}
