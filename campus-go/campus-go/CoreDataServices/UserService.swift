//
//  ProfileService.swift
//  campus-go
//
//  Created by Vitor Jundi Moriya on 25/11/21.
//

import CoreData
import UIKit

class UserService {
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func create(name: String) {
        
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: context)!
        let user = NSManagedObject(entity: userEntity, insertInto: context)
        user.setValue(name, forKey: "name")
        
        try! context.save()
        
    }
    
    func read() throws -> User? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.fetchLimit = 1
        let result = try context.fetch(fetchRequest).first
        return result as? User
    }

    
    func update(name: String) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let obj = try context.fetch(fetchRequest).first as! NSManagedObject
        obj.setValue(name, forKey: "name")
        try context.save()
    }
    
}
