//
//  PersistenceController.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let referenceDate = Date(timeIntervalSince1970: 1679306950)
        
        // Generate some fake content
        [
            (name: "Back Squat", oneRepMax: 100),
            (name: "Barbell Bench Press", oneRepMax: 150)
        ].forEach { exercise in
            let newExercise = CDExercise(context: viewContext)
            newExercise.id = UUID()
            newExercise.name = exercise.name
            newExercise.overallOneRepMax = NSDecimalNumber(value: exercise.oneRepMax)
            
            (0..<10).reversed().forEach {
                let oneRepMax = CDOneRepMax(context: viewContext)
                oneRepMax.id = UUID()
                // Go back from the reference date in increments of 30 days (trying to get different months)
                oneRepMax.date = referenceDate.addingTimeInterval(Double($0) * -86400 * 30)
                let randomMax = round(Double.random(in: 100...200) * 10) / 10
                oneRepMax.oneRepMax = NSDecimalNumber(value: randomMax)
                oneRepMax.exercise = newExercise
            }
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            assertionFailure("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "OneRepMax")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
