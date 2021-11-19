//
//  Place+CoreDataProperties.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 17/11/21.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var placeID: Int64
    @NSManaged public var uid: UUID?
    @NSManaged public var nImages: Int64
    @NSManaged public var state: Int64
    @NSManaged public var relatedAchievements: NSSet?

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
