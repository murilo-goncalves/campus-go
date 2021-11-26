//
//  User+CoreDataProperties.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 17/11/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var xpPoints: Int64

}

extension User : Identifiable {

}
