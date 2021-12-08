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
    
    func create(achievementID: Int64, objective: String, name: String, progress: Double, xpPoints: Int64, relatedPlaces: String, nVisits: Int64) throws -> Achievement? {
        let achievementEntity = NSEntityDescription.entity(forEntityName: "Achievement", in: context)!
        let achievement = NSManagedObject(entity: achievementEntity, insertInto: context)
        let uid = UUID()
        achievement.setValue(progress, forKey: "progress")
        achievement.setValue(name, forKey: "name")
        achievement.setValue(xpPoints, forKey: "xpPoints")
        achievement.setValue(achievementID, forKey: "achievementID")
        achievement.setValue(uid, forKey: "uid")
        achievement.setValue(objective, forKey: "objective")
        achievement.setValue(relatedPlaces, forKey: "relatedPlaces")
        achievement.setValue(nVisits, forKey: "nVisits")
        
        try context.save()

        return achievement as? Achievement
        
    }
    func retrieve() throws -> [Achievement]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Achievement")
    
        let result = try context.fetch(fetchRequest)
        guard var achievements = (result as? [Achievement]) else { return nil }
        achievements.sort(by: {
            if $0.progress == $1.progress {
                return $0.name! < $1.name!
            }
            return $0.progress > $1.progress
        })
        return achievements
        
    }
        
    func retrieve(uid: UUID) throws -> Achievement? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Achievement")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid as CVarArg)

        let result = try context.fetch(fetchRequest)
        return result[0] as? Achievement
    }
    
    func retrieve(achievementID: Int64) throws -> UUID? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Achievement")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "achievementID = \(achievementID)", achievementID as CVarArg)

        let result = try context.fetch(fetchRequest)
        let achievement = result[0] as? Achievement
        return achievement?.uid
    }
    
    func update(objective: String?, name: String?, progress: Double?, xpPoints: Int64?, uid: UUID) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Achievement")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid as CVarArg)
    
        let result =  try context.fetch(fetchRequest)
        let objectUpdate = result[0] as! NSManagedObject
        
        if let newObjective = objective {
            objectUpdate.setValue(newObjective, forKey: "objective")
        }
        if let newName = name {
            objectUpdate.setValue(newName, forKey: "name")
        }
        if let newProgress = progress {
            objectUpdate.setValue(newProgress, forKey: "progress")
        }
        if let newXP = xpPoints {
            objectUpdate.setValue(newXP, forKey: "xpPoints")
        }
        try context.save()
        
    }
    
    func updateProgress(uid: UUID, progress: Double?) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Achievement")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid as CVarArg)
        
        let result =  try context.fetch(fetchRequest)
        let objectUpdate = result[0] as! NSManagedObject
        
        if let newProgress = progress {
            objectUpdate.setValue(newProgress, forKey: "progress")
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
    
    func retrieveByUUIDs(uuids: [UUID]) -> [Achievement] {
        var achievements: [Achievement] = []
        for uuid in uuids {
            do {
                if let achievement = try retrieve(uid: uuid) {
                    achievements.append(achievement)
                }
            } catch {
                continue
            }
        }
        return achievements
    }
}
