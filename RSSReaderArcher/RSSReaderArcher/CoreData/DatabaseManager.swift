//
//  DatabaseManager.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/2/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import Foundation
import CoreData

enum SaveStatus {
    case saved
    case rolledBack
    case noChanges
    case error
}

protocol StoreManager {
    var privateContext: NSManagedObjectContext { get }
    var mainContext: NSManagedObjectContext { get }
    
    func save(_ block:(()-> Void)?, completion:((SaveStatus)-> Void)?)
}

public class DatabaseManager: StoreManager {
    
    static let shared = DatabaseManager()
    var privateContext: NSManagedObjectContext {
        return privateWriterContext
    }
    
    var mainContext: NSManagedObjectContext {
        return mainObjectContext
    }
    
    /* block will be execute on background Thread, completion on Main */
    func save(_ block:(() -> Void)? = nil, completion:((SaveStatus) -> Void)? = nil) {
        self.privateContext.perform { [weak self] in
            block?()
            do {
                try self?.privateContext.save()
                self?.mainObjectContext.performAndWait { [weak self] in
                    do {
                        try self?.mainObjectContext.save()
                        completion?(.saved)
                    } catch {
                        completion?(.rolledBack)
                        print("CoreData: Unresolved error \(error.localizedDescription)")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(.rolledBack)
                }
                print("CoreData: Unresolved error \(error.localizedDescription)")
            }
        }
    }
    
    private init() {}
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        do {
            return try NSPersistentStoreCoordinator.coordinator(name: "RSSReaderArcher")
        } catch {
            print("CoreData: Unresolved error \(error)")
        }
        return nil
    }()
    
    private lazy var privateWriterContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.parent = self.mainContext
        
        return managedObjectContext
    }()
    
    private lazy var mainObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
}

extension NSPersistentStoreCoordinator {
    
    public enum CoordinatorError: Error {
        case modelFileNotFound
        case modelCreationError
        case storePathNotFound
    }
    
    static func coordinator(name: String) throws -> NSPersistentStoreCoordinator? {
        guard let modelURL = Bundle.main.url(forResource: name, withExtension: "momd") else {
            throw CoordinatorError.modelFileNotFound
        }
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CoordinatorError.modelCreationError
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            throw CoordinatorError.storePathNotFound
        }
        
        do {
            let url = documents.appendingPathComponent(String(format: "%@.sqlite", name))
            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                           NSInferMappingModelAutomaticallyOption: true] as [String : Any]
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
            
        } catch {
            throw error
        }
        
        return coordinator
    }
    
    
}
