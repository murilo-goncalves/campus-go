//
//  achievementService.swift
//  campus-go
//
//  Created by Luiz Gustavo Silva Aguiar on 03/11/21.
//

import CoreData
import UIKit

class AchievementService{
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    func create(achievementID: Int64, objective: String, name: String, progress: Double, xpPoints: Int64) throws -> Achievement? {
        let achievementEntity = NSEntityDescription.entity(forEntityName: "Achievement", in: context)!
        let achievement = NSManagedObject(entity: achievementEntity, insertInto: context)
        let uid = UUID()
        achievement.setValue(progress, forKey: "progress")
        achievement.setValue(name, forKey: "name")
        achievement.setValue(xpPoints, forKey: "xpPoints")
        achievement.setValue(achievementID, forKey: "achievementID")
        achievement.setValue(uid, forKey: "uid")
        achievement.setValue(objective, forKey: "objective")
        
        
        try context.save()

        return achievement as? Achievement
        
    }
    func retrieve() throws -> [Achievement]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Achievement")
    
        let result = try context.fetch(fetchRequest)
        return result as? [Achievement]
    }
        
    func retrieve(uid: UUID) throws -> Achievement? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Achievement")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid as CVarArg)

        let result = try context.fetch(fetchRequest)
        return result[0] as? Achievement
    }
    
    func update(condition: String?, name: String?, xpPoints: Int64?, uid: UUID) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Achievement")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid as CVarArg)
    
        let result =  try context.fetch(fetchRequest)
        let objectUpdate = result[0] as! NSManagedObject
        
        if let newCondition = condition {
            objectUpdate.setValue(newCondition, forKey: "condition")
        }
        
        if let newName = name {
            objectUpdate.setValue(newName, forKey: "name")
        }
        
        if let newXp = xpPoints {
            objectUpdate.setValue(newXp, forKey: "xpPoints")
        }
        try context.save()
        
    }
    
    func delete(uid: UUID) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Achievement")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid as CVarArg)
        
        let result = try context.fetch(fetchRequest)
        let objectToDelete = result[0] as! NSManagedObject
        context.delete(objectToDelete)
        
        try context.save()
        
    }
}
