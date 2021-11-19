//
//  Achievement+CoreDataProperties.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 17/11/21.
//
//

import Foundation
import CoreData


extension Achievement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Achievement> {
        return NSFetchRequest<Achievement>(entityName: "Achievement")
    }

    @NSManaged public var condition: String?
    @NSManaged public var name: String?
    @NSManaged public var uid: UUID?
    @NSManaged public var xpPoints: Int64
    @NSManaged public var relatedPlaces: NSSet?

}

// MARK: Generated accessors for relatedPlaces
extension Achievement {

    @objc(addRelatedPlacesObject:)
    @NSManaged public func addToRelatedPlaces(_ value: Place)

    @objc(removeRelatedPlacesObject:)
    @NSManaged public func removeFromRelatedPlaces(_ value: Place)

    @objc(addRelatedPlaces:)
    @NSManaged public func addToRelatedPlaces(_ values: NSSet)

    @objc(removeRelatedPlaces:)
    @NSManaged public func removeFromRelatedPlaces(_ values: NSSet)

}

extension Achievement : Identifiable {

}
