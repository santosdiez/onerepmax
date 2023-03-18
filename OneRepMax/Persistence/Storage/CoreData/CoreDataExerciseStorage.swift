//
//  Persistence.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 16/3/23.
//

import Combine
import CoreData

class CoreDataExerciseStorage: NSObject, ExerciseStorage {
    var exercises = CurrentValueSubject<[Exercise], Never>([])
    private let exerciseFetchController: NSFetchedResultsController<CDExercise>
    private let persistenceController: PersistenceController
    
    static var preview = CoreDataExerciseStorage(
        persistenceController: PersistenceController.preview
    )
    
    static let shared = CoreDataExerciseStorage()
    
    private init(persistenceController: PersistenceController = PersistenceController.shared) {
        self.persistenceController = persistenceController
        
        let fetchRequest = CDExercise.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CDExercise.name, ascending: true)]
        
        exerciseFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: persistenceController.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
        
        exerciseFetchController.delegate = self
        
        do {
            try exerciseFetchController.performFetch()
            exercises.value = exerciseFetchController.fetchedExercises ?? []
        } catch {
            // TBD: Handle error
        }
    }
    
    func add(exercises: [Exercise]) throws {
        let context = persistenceController.container.viewContext
        
        exercises.forEach {
            let coreDataExercise = CDExercise(context: context)
            coreDataExercise.name = $0.name
            
            $0.logs.forEach {
                let coreDataLog = CDExerciseLog(context: context)
                coreDataLog.date = $0.date
                coreDataLog.sets = Int16($0.sets)
                coreDataLog.reps = Int16($0.reps)
                coreDataLog.weight = $0.weight
                coreDataLog.oneRepMax = $0.oneRepMax
                coreDataLog.exercise = coreDataExercise
            }
        }
        
        try context.save()
    }
    
    func deleteAll() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: CDExercise.fetchRequest())

        deleteRequest.resultType = .resultTypeObjectIDs

        let context = persistenceController.container.viewContext

        let batchDelete = try? context.execute(deleteRequest) as? NSBatchDeleteResult

        guard let deleteResult = batchDelete?.result as? [NSManagedObjectID] else {
            return
        }

        let deletedObjects: [AnyHashable: Any] = [
            NSDeletedObjectsKey: deleteResult
        ]

        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: deletedObjects,
            into: [context]
        )
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension CoreDataExerciseStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let exercisesController = controller as? NSFetchedResultsController<CDExercise> else { return }
        exercises.value = exercisesController.fetchedExercises ?? []
    }
}

// MARK: - NSFetchedResultsController: Utility extension to return already converted results
extension NSFetchedResultsController where ResultType == CDExercise {
    var fetchedExercises: [Exercise]? {
        return fetchedObjects?.map { Exercise.fromCoreData(instance: $0) }
    }
}

// MARK: - CDExercise: Utility extension to return a typed collection for the logs
private extension CDExercise {
    var typedLogs: [CDExerciseLog]? {
        logs?.allObjects as? [CDExerciseLog]
    }
}

private extension Exercise {
    static func fromCoreData(instance: CDExercise) -> Exercise {
        let logs = instance.typedLogs?.compactMap { ExerciseLog.fromCoreData(instance: $0) } ?? []
        
        return Exercise(id: instance.id, name: instance.name ?? "-", logs: logs)
    }
}

private extension ExerciseLog {
    static func fromCoreData(instance: CDExerciseLog) -> ExerciseLog? {
        guard let date = instance.date else { return nil }
              
        return ExerciseLog(
            id: instance.id,
            date: date,
            sets: Int(instance.sets),
            reps: Int(instance.reps),
            weight: instance.weight,
            oneRepMax: instance.oneRepMax
        )
    }
}
