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
    func create(condition: String, name: String, xpPoints: Int64) -> Achievement? {
        let achievementEntity = NSEntityDescription.entity(forEntityName: "Achievement", in: context)!
        let achievement = NSManagedObject(entity: achievementEntity, insertInto: context)
        let uid = UUID();
        achievement.setValue(condition, forKey: "condition")
        achievement.setValue(name, forKey: "name")
        achievement.setValue(xpPoints, forKey: "xpPoints")
        achievement.setValue(uid, forKey: "uid")
        
        do {
            try context.save()
        } catch {
            print("Não foi possível criar a nova conquista")
        }
        return achievement as? Achievement
        
    }
    func retrieve() -> [Achievement]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Achievement")
        
        do {
            let result = try context.fetch(fetchRequest)
            return result as? [Achievement]
        } catch {
            print("Não foi possível ler as conquistas")
        }
        return nil
    }
        
    func retrieve(uid: UUID) -> Achievement? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Achievement")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid as CVarArg)
        
        do {
            let result = try context.fetch(fetchRequest)
            return result[0] as? Achievement
        } catch {
            print("Não existe conquista com este uid \(uid)")
        }
        return nil
    }
    
    func update(condition: String?, name: String?, xpPoints: Int64?, uid: UUID) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Achievement")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid as CVarArg)
        
        do {
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
            
            do {
                try context.save()
            } catch {
                print("Não foi possível salvar as alterações nesta conquista")
            }
        } catch {
            print("Não foi possível encontrar uma conquista com esse uid")
        }
        
    }
    
    func delete(uid: UUID) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Achievement")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid as CVarArg)
        
        do {
            let result = try context.fetch(fetchRequest)
            let objectToDelete = result[0] as! NSManagedObject
            context.delete(objectToDelete)
            
            do {
                try context.save()
            }
            catch {
               print("Não foi possível deletar a conquista")
            }
            
        } catch {
            print("Esta conquista não existe ou já foi deletada")
        }
        
    }
}
