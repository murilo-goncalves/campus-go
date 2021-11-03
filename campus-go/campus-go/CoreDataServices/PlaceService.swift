//
//  PlaceService.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 03/11/21.
//

// DÚVIDAS ORDINE
// temos que setar relacionamentos ou apenas atributos na criação dos obj?
// melhor forma de atualizar os campos de um objeto, varias funções sobrecarregadas, uma unica com param nulos
//

import CoreData
import UIKit

class PlaceService {
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func create(name: String) {
        let placeEntity = NSEntityDescription.entity(forEntityName: "Place", in: context)!
        let place = NSManagedObject(entity: placeEntity, insertInto: context)
        place.setValue(name, forKey: "name")
        
        do {
            try context.save()
        } catch {
            print("NÃO FOI POSSÍVEL CRIAR O LUGAR COM NOME \(name)")
        }
    }
    
    func read() -> [Place]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        
        do {
            let result = try context.fetch(fetchRequest)
            return result as? [Place]
        } catch {
            print("NÃO FOI POSSÍVEL LER OS LUGARES")
            return nil
        }
    }
    
    func read(uid: UUID) -> Place? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid as CVarArg)
        
        do {
            let result = try context.fetch(fetchRequest)
            return result[0] as? Place
        } catch {
            print("NÃO FOI POSSÍVEL LER O LUGAR \(uid)")
            return nil
        }
    }

    
    func update(newObj: NSManagedObject, uid: UUID) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid as CVarArg)
        
        do {
            let obj = try context.fetch(fetchRequest)
            let objUpdate = obj[0] as! NSManagedObject
            objUpdate.setValue((newObj as! Place).name, forKey: "name")
            do {
                try context.save()
            } catch {
                print("NÃO FOI POSSÍVEL SALVAR A ATUALIZAÇÃO DO LUGAR \(uid)")
            }
        } catch {
            print("NÃO FOI POSSÍVEL ATUALIZAR O LUGAR \(uid)")
        }
    }
    
    func delete(uid: UUID) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid as CVarArg)
        
        do {
            let obj = try context.fetch(fetchRequest)
            let objToDelete = obj[0] as! NSManagedObject
            context.delete(objToDelete)
            do {
                try context.save()
            } catch {
                print("NÃO FOI POSSÍVEL SALVAR A REMOÇÃO DO LUGAR \(uid)")
            }
        } catch {
            print("NÃO FOI POSSÍVEL REMOVER O LUGAR \(uid)")
        }
    }
}
