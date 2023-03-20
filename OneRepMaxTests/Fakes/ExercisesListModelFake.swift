//
//  ExercisesListModelFake.swift
//  OneRepMaxTests
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Combine
import Foundation
@testable import OneRepMax

struct ExercisesListModelFake: ExercisesListModelProtocol {
    var exercises: AnyPublisher<[ExercisesListItem], Never>
    
    private let fakeItems: [String: Decimal] = [
        "Back Squat": 100,
        "Barbell Bench Press": 80,
        "Dumbbell Row": 50,
        "Barbell Curl": 25.5,
        "Cable Row": 60,
        "Dumbbell Fly": 30.5
    ]
    
    init() {
        exercises = [fakeItems.map { name, oneRepMax in
            ExercisesListItem(id: UUID(), name: name, oneRepMax: oneRepMax)
        }.sorted(by: { $0.name < $1.name })].publisher.eraseToAnyPublisher()
    }
}
