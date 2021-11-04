//
//  Place+CoreDataProperties.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 03/11/21.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var name: String?
    @NSManaged public var uid: UUID?
    @NSManaged public var coordinate: Coordinate?
    @NSManaged public var isVisited: NSSet?
    @NSManaged public var relatedAchievements: NSSet?

}

// MARK: Generated accessors for isVisited
extension Place {

    @objc(addIsVisitedObject:)
    @NSManaged public func addToIsVisited(_ value: Visits)

    @objc(removeIsVisitedObject:)
    @NSManaged public func removeFromIsVisited(_ value: Visits)

    @objc(addIsVisited:)
    @NSManaged public func addToIsVisited(_ values: NSSet)

    @objc(removeIsVisited:)
    @NSManaged public func removeFromIsVisited(_ values: NSSet)

}

// MARK: Generated accessors for relatedAchievements
extension Place {

    @objc(addRelatedAchievementsObject:)
    @NSManaged public func addToRelatedAchievements(_ value: Achievement)

    @objc(removeRelatedAchievementsObject:)
    @NSManaged public func removeFromRelatedAchievements(_ value: Achievement)

    @objc(addRelatedAchievements:)
    @NSManaged public func addToRelatedAchievements(_ values: NSSet)

    @objc(removeRelatedAchievements:)
    @NSManaged public func removeFromRelatedAchievements(_ values: NSSet)

}

extension Place : Identifiable {

}
