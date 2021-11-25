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

    @NSManaged public var progress: Double
    @NSManaged public var name: String
    @NSManaged public var uid: UUID
    @NSManaged public var xpPoints: Int64
    @NSManaged public var achievementID: String

}



extension Achievement : Identifiable {

}
