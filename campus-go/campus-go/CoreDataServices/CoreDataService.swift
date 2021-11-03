//
//  CoreDataService.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 03/11/21.
//

import CoreData
import UIKit

protocol CoreDataService {
    func create(newObj: NSManagedObject)
    
    func read(uid: UUID) -> NSManagedObject
    
    func update(newObj: NSManagedObject, uid: UUID)
    
    func delete(uid: UUID)
}

extension CoreDataService {
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}
