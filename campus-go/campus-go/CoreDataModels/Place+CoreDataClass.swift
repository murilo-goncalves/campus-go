//
//  Place+CoreDataClass.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 09/11/21.
//
//

import Foundation
import CoreData

@objc(Place)
public class Place: NSManagedObject, Codable {
    
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var uid: UUID?
    @NSManaged public var placeID: Int16
    @NSManaged public var isVisited: NSSet?
    @NSManaged public var relatedAchievements: NSSet?
    
    enum CodingKeys: CodingKey {
        case latitude, longitude, placeID, name
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "Place", in: context) else { fatalError() }

        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.placeID = try container.decode(Int16.self, forKey: .placeID)
        self.name = try container.decode(String.self, forKey: .name)

    }
    
    // MARK: - Decodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(name, forKey: .name)
        try container.encode(placeID, forKey: .placeID)
    }
}

    
extension CodingUserInfoKey {
  static let context = CodingUserInfoKey(rawValue: "context")
}

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}
