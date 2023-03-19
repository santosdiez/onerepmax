//
//  ExerciseLog.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Foundation

struct ExerciseLog {
    /// Unique identifier for a given instance
    let id: UUID
    
    /// Date when the exercise was performed
    let date: Date
    
    /// Number of sets
    let sets: Int
    
    /// Number of repetitions
    let reps: Int
    
    /// Weight used when performing the exercise
    let weight: Decimal
    
    init(
        id: UUID,
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
