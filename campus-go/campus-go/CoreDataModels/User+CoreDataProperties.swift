//
//  User+CoreDataProperties.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 09/11/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: Int64
    @NSManaged public var uid: UUID?
    @NSManaged public var xpPoints: Int64
    @NSManaged public var achievements: NSSet?
    @NSManaged public var patents: NSSet?
    @NSManaged public var visits: NSSet?

}

// MARK: Generated accessors for achievements
extension User {

    @objc(addAchievementsObject:)
    @NSManaged public func addToAchievements(_ value: Achievement)

    @objc(removeAchievementsObject:)
    @NSManaged public func removeFromAchievements(_ value: Achievement)

    @objc(addAchievements:)
    @NSManaged public func addToAchievements(_ values: NSSet)

    @objc(removeAchievements:)
    @NSManaged public func removeFromAchievements(_ values: NSSet)

}

// MARK: Generated accessors for patents
extension User {

    @objc(addPatentsObject:)
    @NSManaged public func addToPatents(_ value: Patent)

    @objc(removePatentsObject:)
    @NSManaged public func removeFromPatents(_ value: Patent)

    @objc(addPatents:)
    @NSManaged public func addToPatents(_ values: NSSet)

    @objc(removePatents:)
    @NSManaged public func removeFromPatents(_ values: NSSet)

}

// MARK: Generated accessors for visits
extension User {

    @objc(addVisitsObject:)
    @NSManaged public func addToVisits(_ value: Visits)

    @objc(removeVisitsObject:)
    @NSManaged public func removeFromVisits(_ value: Visits)

    @objc(addVisits:)
    @NSManaged public func addToVisits(_ values: NSSet)

    @objc(removeVisits:)
    @NSManaged public func removeFromVisits(_ values: NSSet)

}

extension User : Identifiable {

}
