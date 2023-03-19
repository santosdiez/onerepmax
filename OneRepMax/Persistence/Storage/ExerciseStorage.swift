//
//  ExerciseStorage.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Combine
import Foundation

protocol ExerciseStorage {
    var exercises: CurrentValueSubject<[Exercise], Never> { get }
    
    func add(exercises: [Exercise]) throws
    func deleteAll() throws
}
