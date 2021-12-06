//
//  Achievement+CoreDataProperties.swift
//  campus-go
//
//  Created by Luiz Gustavo Silva Aguiar on 26/11/21.
//
//

import Foundation
import CoreData


extension Achievement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Achievement> {
        return NSFetchRequest<Achievement>(entityName: "Achievement")
    }

    @NSManaged public var achievementID: Int64
    @NSManaged public var name: String?
    @NSManaged public var progress: Double
    @NSManaged public var uid: UUID?
    @NSManaged public var xpPoints: Int64
    @NSManaged public var objective: String?
    @NSManaged public var relatedPlaces: String?

}

extension Achievement : Identifiable {

}
