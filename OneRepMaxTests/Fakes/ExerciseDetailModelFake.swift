//
//  ExerciseDetailModelFake.swift
//  OneRepMaxTests
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Combine
import Foundation
@testable import OneRepMax

struct ExerciseDetailModelFake: ExerciseDetailModelProtocol {
    var detail: AnyPublisher<ExerciseDetailItem?, Never>
    
    private let dates: [Date] = {
        let startingDate = Date(timeIntervalSince1970: 1679255734)
        return (0..<10).map {
            startingDate.addingTimeInterval(Double($0) * 86400 * 30)
        }
    }()
    
    init() {
        detail = [
            ExerciseDetailItem(
                exerciseListItem: ExercisesListItem(
                    id: UUID(),
                    name: "Back Squat",
                    oneRepMax: 100
                ),
                oneRepMaxData: dates.map {
                    OneRepMaxItem(id: UUID(), date: $0, value: 100)
                })
        ].publisher.eraseToAnyPublisher()
    }
            
    func fetchExercise() {}
}
