//
//  Coordinate+CoreDataProperties.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 03/11/21.
//
//

import Foundation
import CoreData


extension Coordinate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coordinate> {
        return NSFetchRequest<Coordinate>(entityName: "Coordinate")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var place: Place?

}

extension Coordinate : Identifiable {

}
