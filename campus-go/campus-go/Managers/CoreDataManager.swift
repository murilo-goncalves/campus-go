//
//  CoreDataManager.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 26/10/21.
//

import CoreData

final class CoreDataManager {
    
    // MARK: - Properties
    
    private let modelName: String
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = self.managedObjectContext.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoodinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(type: NSPersistentStore.StoreType(
                                                                    rawValue: NSSQLiteStoreType),
                                                              configuration: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    // MARK: - Initialization
    
    init(modelName: String) {
        self.modelName = modelName
        
        // MARK: - Core Data Stack
        
        
//        private lazy var managedObjectModel: NSManagedObjectModel = {}()
//        private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {}()
    }
}
