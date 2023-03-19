//
//  StorageManager.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Foundation

/// Utility enum intended to store the chosen implementation for the different storage protocols
enum StorageManager {
    static let exerciseStorage: ExerciseStorage = CoreDataExerciseStorage.shared
    static let exerciseStoragePreview: ExerciseStorage = CoreDataExerciseStorage.preview
}
