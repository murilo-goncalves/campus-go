//
//  Achievement+CoreDataProperties.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 28/10/21.
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
    @NSManaged public var xpPoints: Int64
    @NSManaged public var relatedPlaces: NSSet?
    @NSManaged public var users: NSSet?

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

// MARK: Generated accessors for users
extension Achievement {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: User)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: User)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}

extension Achievement : Identifiable {

}
