//
//  Visits+CoreDataProperties.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 28/10/21.
//
//

import Foundation
import CoreData


extension Visits {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Visits> {
        return NSFetchRequest<Visits>(entityName: "Visits")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var user: User?
    @NSManaged public var place: Place?

}

extension Visits : Identifiable {

}
