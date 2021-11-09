//
//  Visits+CoreDataProperties.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 04/11/21.
//
//

import Foundation
import CoreData


extension Visits {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Visits> {
        return NSFetchRequest<Visits>(entityName: "Visits")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var uid: UUID?
    @NSManaged public var place: Place?
    @NSManaged public var user: User?

}

extension Visits : Identifiable {

}
