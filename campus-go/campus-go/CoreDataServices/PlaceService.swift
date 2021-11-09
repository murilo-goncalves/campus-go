//
//  PlaceService.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 03/11/21.
//

// DÚVIDAS ORDINE
// Respondidas:
// temos que setar relacionamentos ou apenas atributos na criação dos obj? Ambos
// melhor forma de atualizar os campos de um objeto, varias funções sobrecarregadas, uma unica com param nulos? Uma única
// Não respondidas:
// Como e onde inicializar os relacionamentos
//


import CoreData
import UIKit

class PlaceService {
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func create(name: String, latitude: Double, longitude: Double) throws -> UUID {
        let placeEntity = NSEntityDescription.entity(forEntityName: "Place", in: context)!
        let place = NSManagedObject(entity: placeEntity, insertInto: context)
        
        let uid = UUID()
        place.setValue(name, forKey: "name")
        place.setValue(uid, forKey: "uid")
        
        try context.save()
        
        return uid
    }
    
    func readAll() throws -> [Place]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
    
        let result = try context.fetch(fetchRequest)
        return result as? [Place]
    }
    
    func read(uid: UUID) throws -> Place? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid as CVarArg)

        let result = try context.fetch(fetchRequest)
        return result[0] as? Place
    }

    
    func update(uid: UUID, name: String, latitude: Double, longitude: Double) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid as CVarArg)
        let obj = try context.fetch(fetchRequest)
        let objUpdate = obj[0] as! NSManagedObject
        objUpdate.setValue(name, forKey: "name")
        objUpdate.setValue(latitude, forKey: "latitude")
        objUpdate.setValue(longitude, forKey: "longitude")
        try context.save()
    }
    
    func delete(uid: UUID) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        fetchRequest.predicate = NSPredicate(format: "uid = %@", uid as CVarArg)
        let obj = try context.fetch(fetchRequest)
        let objToDelete = obj[0] as! NSManagedObject
        context.delete(objToDelete)
        try context.save()
    }
}
