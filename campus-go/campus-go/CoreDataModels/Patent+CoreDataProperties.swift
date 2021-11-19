//
//  Patent+CoreDataProperties.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 17/11/21.
//
//

import Foundation
import CoreData


extension Patent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patent> {
        return NSFetchRequest<Patent>(entityName: "Patent")
    }

    @NSManaged public var name: String?
    @NSManaged public var uid: UUID?
    @NSManaged public var xpPoints: Int64

}

extension Patent : Identifiable {

}
