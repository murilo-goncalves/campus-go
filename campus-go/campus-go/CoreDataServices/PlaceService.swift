//
//  PlaceService.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 03/11/21.
//

import CoreData
import UIKit

class PlaceService: CoreDataService {
    var context: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func create(newObj: NSManagedObject) {
        <#code#>
    }
    
    func read(uid: UUID) -> NSManagedObject {
        <#code#>
    }
    
    func update(newObj: NSManagedObject, uid: UUID) {
        <#code#>
    }
    
    func delete(uid: UUID) {
        <#code#>
    }
}
