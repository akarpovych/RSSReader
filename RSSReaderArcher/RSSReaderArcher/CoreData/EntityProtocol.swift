//
//  EntityProtocol.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/2/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import Foundation
import CoreData

enum ContextType {
    case mainContext
    case privateContext
}

extension NSManagedObject: Entity { }

protocol Entity: class { }

extension Entity where Self: NSManagedObject {
    
    static func createEntity(manager: StoreManager = DatabaseManager.shared) -> Self? {
        guard let object = NSEntityDescription.insertNewObject(forEntityName: self.className,
                                                               into: manager.privateContext) as? Self else { return nil }
        return object
    }
    
    static func count(manager: StoreManager = DatabaseManager.shared,
                      predicate: NSPredicate? = nil,
                      sort: [NSSortDescriptor]? = nil) -> Int {
        guard let request = fetchRequest(predicate: predicate, sort: sort) as? NSFetchRequest<Self> else { return 0 }
        do {
            return try manager.mainContext.count(for: request)
        } catch {
            print("Failed all")
            return 0
        }
    }
    
    static func all(manager: StoreManager = DatabaseManager.shared,
                    predicate: NSPredicate? = nil,
                    sort: [NSSortDescriptor]? = nil) -> [Self]? {
        guard let request = fetchRequest(predicate: predicate, sort: sort) as? NSFetchRequest<Self> else { return nil }
        do {
            return try manager.mainContext.fetch(request)
        } catch {
            print("Failed all")
            return nil
        }
    }
    
    static func all(manager: StoreManager = DatabaseManager.shared,
                    predicate: NSPredicate? = nil,
                    sort:[NSSortDescriptor]? = nil,
                    completion:(([Self]) -> Void)? = nil) {
        guard let request = fetchRequest(predicate: predicate, sort: sort) as? NSFetchRequest<Self> else { return }
        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: request) { asynchronousFetchResult in
            
            DispatchQueue.main.async {
                completion?(asynchronousFetchResult.finalResult ?? [Self]())
            }
        }
        
        do {
            try manager.privateContext.execute(asyncRequest)
        } catch {
            print("Failed fetch all items ")
        }
    }
    
    static func first(manager: StoreManager = DatabaseManager.shared,
                      predicate: NSPredicate? = nil,
                      sort: [NSSortDescriptor]? = nil) -> Self? {
        return all(manager: manager, predicate: predicate, sort: sort)?.first
    }
    
    static func deleteAll(manager: StoreManager = DatabaseManager.shared,
                          predicate: NSPredicate? = nil,
                          sort: [NSSortDescriptor]? = nil,
                          completion:((SaveStatus)-> Void)? = nil) {
        
        guard let request = fetchRequest(predicate: predicate, sort: sort) as? NSFetchRequest<Self> else { return }
        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: request) { asynchronousFetchResult in
            asynchronousFetchResult.finalResult?.forEach { manager.privateContext.delete($0 as NSManagedObject) }
            
            manager.save(nil) { status in
                DispatchQueue.main.async {
                    completion?(status)
                }
            }
        }
        
        do {
            try manager.privateContext.execute(asyncRequest)
        } catch {
            print("Failed fetch all items ")
        }
    }
    
    static func fetchedResultsController(manager: StoreManager = DatabaseManager.shared,
                                         predicate: NSPredicate? = nil,
                                         sort: [NSSortDescriptor]? = nil,
                                         cacheName: String? = nil) -> NSFetchedResultsController<Self> {
        let request = fetchRequest(predicate: predicate, sort: sort)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: manager.mainContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: cacheName)
        return fetchedResultsController as! NSFetchedResultsController<Self>
    }
    
    private static func fetchRequest(predicate: NSPredicate? = nil,
                                     sort: [NSSortDescriptor]? = nil) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.className)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = sort
        
        return request
    }
    
    func delete(context: ContextType = .mainContext,
                manager: StoreManager = DatabaseManager.shared,
                saveImmediately: Bool = true,
                completion:((SaveStatus) -> Void)? = nil) {
        switch context {
        case .mainContext:
            manager.mainContext.delete(self)
        case .privateContext:
            manager.privateContext.delete(self)
        }
        
        if saveImmediately {
            manager.save(nil) { status in
                completion?(status)
            }
        } else {
            completion?(.noChanges)
        }
    }
}
