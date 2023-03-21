//
//  FakeData.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez Vázquez on 21/3/23.
//

import Foundation

enum FakeData {
    static let exerciseNames = ["Back Squat", "Barbell Bench Press"]
    static let oneRepMaxDates: [Date] = {
        let referenceDate = Date(timeIntervalSince1970: 1679306950)

        return (0..<10).reversed().map {
            referenceDate.addingTimeInterval(Double($0) * -86400 * 15)
        }
    }()
    static let oneRepMaxValues: [Decimal] = [100, 150, 180, 175, 150.5, 110, 210, 220, 250, 240]
    static let oneRepMaxItems: [OneRepMax] = {
        oneRepMaxDates.enumerated().map { index, date in
            OneRepMax(
                id: UUID(),
                date: date,
                oneRepMax: oneRepMaxValues[index]
            )
        }
    }()

    static let exercises: [Exercise] = {
        exerciseNames.map { name in
            Exercise(
                id: UUID(),
                name: name,
                logs: [],
                oneRepMaxs: oneRepMaxItems,
                overallOneRepMax: oneRepMaxValues.max()
            )
        }
    }()
}
