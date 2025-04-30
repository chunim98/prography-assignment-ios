//
//  CoreDataStack.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/30/25.
//

import CoreData

final class CoreDataStack {
    
    // MARK: Properties
    private let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    // MARK: Intializer
    
    init() {
        let container = NSPersistentContainer(name: "PrographyAssignment")
        container.loadPersistentStores { _, error in
            if let error { fatalError(error.localizedDescription) }
        }
        self.persistentContainer = container
    }
    
    // MARK: Core Data Support Methods

    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError(nserror.localizedDescription)
        }
    }
}
