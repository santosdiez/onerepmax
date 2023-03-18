//
//  Exercise.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Foundation

struct Exercise {
    let id: ObjectIdentifier?
    let name: String
    let logs: [ExerciseLog]
    
    init(
        id: ObjectIdentifier? = nil,
        name: String,
        logs: [ExerciseLog]
    ) {
        self.id = id
        self.name = name
        self.logs = logs
    }
}
