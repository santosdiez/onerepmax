//
//  ExerciseLog.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Foundation

struct ExerciseLog {
    let id: ObjectIdentifier?
    let date: Date
    let sets: Int
    let reps: Int
    let weight: Double
    let oneRepMax: Double
    
    init(
        id: ObjectIdentifier? = nil,
        date: Date,
        sets: Int,
        reps: Int,
        weight: Double,
        oneRepMax: Double
    ) {
        self.id = id
        self.date = date
        self.sets = sets
        self.reps = reps
        self.weight = weight
        self.oneRepMax = oneRepMax
    }
}
