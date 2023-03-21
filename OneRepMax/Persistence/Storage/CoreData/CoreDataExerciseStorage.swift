//
//  Persistence.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 16/3/23.
//

import Combine
import CoreData

class CoreDataExerciseStorage: NSObject, ExerciseStorage {
    private enum Constants {
        static let exercisesCacheName = "exercises"
        static let exerciseDetailCacheName = "exerciseDetail"
    }
    
    var exercises = CurrentValueSubject<[Exercise], Never>([])
    var exerciseDetail = CurrentValueSubject<Exercise?, Never>(nil)
    
    private lazy var exercisesFetchController: NSFetchedResultsController<CDExercise> = {
        let fetchRequest = CDExercise.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CDExercise.name, ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: persistenceController.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: Constants.exercisesCacheName
        )
        
        controller.delegate = self
        
        return controller
    }()

    private lazy var exerciseDetailFetchController: NSFetchedResultsController<CDExercise> = {
        let fetchRequest = CDExercise.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CDExercise.name, ascending: true)]
        fetchRequest.fetchLimit = 1
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: persistenceController.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: Constants.exerciseDetailCacheName
        )
        
        controller.delegate = self
        
        return controller
    }()
    
    private let persistenceController: PersistenceController
    
    static let shared = CoreDataExerciseStorage()
    
    static let preview: CoreDataExerciseStorage = {
        let storage = CoreDataExerciseStorage(
            persistenceController: PersistenceController.preview
        )
        
        // Add fake data
        try? storage.add(exercises: FakeData.exercises)
        
        return storage
    }()
    
    private init(persistenceController: PersistenceController = PersistenceController.shared) {
        self.persistenceController = persistenceController
        super.init()
                
        do {
            try exercisesFetchController.performFetch()
            exercises.value = exercisesFetchController.fetchedExercises ?? []
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func fetchExercise(by id: UUID) throws {
        exerciseDetailFetchController.fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        NSFetchedResultsController<CDExercise>.deleteCache(withName: Constants.exerciseDetailCacheName)
        try exerciseDetailFetchController.performFetch()
        exerciseDetail.value = exerciseDetailFetchController.fetchedExercises?.first
    }
        
    func add(exercises: [Exercise]) throws {
        let context = persistenceController.container.viewContext
        
        exercises.forEach {
            let coreDataExercise = CDExercise(context: context)
            coreDataExercise.id = $0.id
            coreDataExercise.name = $0.name
            coreDataExercise.overallOneRepMax = $0.overallOneRepMax as NSDecimalNumber?
            
            $0.oneRepMaxs.forEach {
                let coreDataOneRM = CDOneRepMax(context: context)
                coreDataOneRM.id = $0.id
                coreDataOneRM.date = $0.date
                coreDataOneRM.oneRepMax = NSDecimalNumber(decimal: $0.oneRepMax)
                coreDataOneRM.exercise = coreDataExercise
            }
            
            $0.logs.forEach {
                let coreDataLog = CDExerciseLog(context: context)
                coreDataLog.id = $0.id
                coreDataLog.date = $0.date
                coreDataLog.sets = Int16($0.sets)
                coreDataLog.reps = Int16($0.reps)
                coreDataLog.weight = NSDecimalNumber(decimal: $0.weight)
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
        
        if controller == exercisesFetchController {
            exercises.value = exercisesController.fetchedExercises ?? []
        }
        
        if controller == exerciseDetailFetchController {
            exerciseDetail.value = exercisesController.fetchedExercises?.first
        }
    }
}

// MARK: - NSFetchedResultsController: Utility extension to return already converted results

extension NSFetchedResultsController where ResultType == CDExercise {
    var fetchedExercises: [Exercise]? {
        return fetchedObjects?.compactMap { Exercise.fromCoreData(instance: $0) }
    }
}

// MARK: - CDExercise: Utility extension to return a typed collection for the logs

private extension CDExercise {
    var typedLogs: [CDExerciseLog]? {
        logs?.allObjects as? [CDExerciseLog]
    }
    
    var typedOneRepMaxs: [CDOneRepMax]? {
        oneRepMaxs?.allObjects as? [CDOneRepMax]
    }
}

// MARK: - Utility extensions to create plain models from CoreData instances

private extension Exercise {
    static func fromCoreData(instance: CDExercise) -> Exercise? {
        guard let id = instance.id,
              let name = instance.name else { return nil }
        
        let logs = instance.typedLogs?.compactMap { ExerciseLog.fromCoreData(instance: $0) } ?? []
        let oneRepMaxs = instance.typedOneRepMaxs?.compactMap { OneRepMax.fromCoreData(instance: $0) } ?? []
        
        return Exercise(
            id: id,
            name: name,
            logs: logs,
            oneRepMaxs: oneRepMaxs,
            overallOneRepMax: instance.overallOneRepMax?.decimalValue
        )
    }
}

private extension ExerciseLog {
    static func fromCoreData(instance: CDExerciseLog) -> ExerciseLog? {
        guard let id = instance.id,
              let date = instance.date,
              let weight = instance.weight?.decimalValue else { return nil }
              
        return ExerciseLog(
            id: id,
            date: date,
            sets: Int(instance.sets),
            reps: Int(instance.reps),
            weight: weight
        )
    }
}

private extension OneRepMax {
    static func fromCoreData(instance: CDOneRepMax) -> OneRepMax? {
        guard let id = instance.id,
              let date = instance.date,
              let oneRepMax = instance.oneRepMax?.decimalValue else { return nil }
        
        return OneRepMax(id: id, date: date, oneRepMax: oneRepMax)
    }
}
