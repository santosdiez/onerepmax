//
//  Exercise.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Foundation

struct Exercise {
    /// Unique identifier of an instance
    let id: UUID
    
    /// Name of the exercise (e.g. "Bench press")
    let name: String
    
    /// Collection of workout logs associated to this exercise
    let logs: [ExerciseLog]

    /// Collection of historical 1RMs, precalculated and stored to save time and resources
    let oneRepMaxs: [OneRepMax]
    
    /// Overall 1RM, stored once again for practical reasons to make it easily accessible
    let overallOneRepMax: Decimal?
    
    init(
        id: UUID,
        name: String,
        logs: [ExerciseLog],
        oneRepMaxs: [OneRepMax],
        overallOneRepMax: Decimal? = nil
    ) {
        self.id = id
        self.name = name
        self.logs = logs
        // Make sure items are sorted by date
        self.oneRepMaxs = oneRepMaxs.sorted(by: { $0.date < $1.date })
        self.overallOneRepMax = overallOneRepMax
    }
}
