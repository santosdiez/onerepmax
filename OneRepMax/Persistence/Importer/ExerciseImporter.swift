//
//  ExerciseImporter.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Foundation

protocol ExerciseImporter {
    var exerciseStorage: ExerciseStorage { get }
    func parseExercises(from url: URL) -> [Exercise]
    func importExercises(from url: URL)
}

extension ExerciseImporter {
    func importExercises(from url: URL) {
        let exercises = parseExercises(from: url)
        do {
            // For simplicity, remove existing data before importing
            try exerciseStorage.deleteAll()
            try exerciseStorage.add(exercises: exercises)
        } catch {
            assertionFailure("Error importing data")
        }
    }
}
