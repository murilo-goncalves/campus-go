//
//  Achievement+CoreDataClass.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 17/11/21.
//
//

import Foundation
import CoreData

@objc(Achievement)
public class Achievement: NSManagedObject, Decodable {
    
    enum CodingKeys: CodingKey {
        case achievementID, name, progress, xpPoints, objective, relatedPlaces, nVisits
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "Achievement", in: context) else { fatalError() }

        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.achievementID = try container.decode(Int64.self, forKey: .achievementID)
        self.name = try container.decode(String.self, forKey: .name)
        self.progress = try container.decode(Double.self, forKey: .progress)
        self.xpPoints = try container.decode(Int64.self, forKey: .xpPoints)
        self.objective = try container.decode(String.self, forKey: .objective)
        self.relatedPlaces = try container.decode(String.self, forKey: .relatedPlaces)
        self.nVisits = try container.decode(Int64.self, forKey: .nVisits)
    }
    
    // MARK: - Decodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(achievementID, forKey: .achievementID)
        try container.encode(name, forKey: .name)
        try container.encode(progress, forKey: .progress)
        try container.encode(xpPoints, forKey: .xpPoints)
        try container.encode(objective, forKey: .objective)
        try container.encode(relatedPlaces, forKey: .relatedPlaces)
        try container.encode(nVisits, forKey: .nVisits)
    }
}
