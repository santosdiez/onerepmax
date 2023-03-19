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
    let weight: Decimal
    
    init(
        id: ObjectIdentifier? = nil,
        date: Date,
        sets: Int,
        reps: Int,
        weight: Decimal
    ) {
        self.id = id
        self.date = date
        self.sets = sets
        self.reps = reps
        self.weight = weight
    }
}
