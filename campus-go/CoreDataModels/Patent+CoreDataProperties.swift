//
//  Patent+CoreDataProperties.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 28/10/21.
//
//

import Foundation
import CoreData


extension Patent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patent> {
        return NSFetchRequest<Patent>(entityName: "Patent")
    }

    @NSManaged public var name: String?
    @NSManaged public var xpPoints: Int64
    @NSManaged public var users: NSSet?

}

// MARK: Generated accessors for users
extension Patent {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: User)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: User)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}

extension Patent : Identifiable {

}
