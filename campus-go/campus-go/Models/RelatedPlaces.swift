//
//  RelatedPlaces.swift
//  campus-go
//
//  Created by Luiz Gustavo Silva Aguiar on 06/12/21.
//

import Foundation

struct RelatedPlaces {
    var achievementPlaces: [UUID] = []
    init(achievement: Achievement) {
        guard let list = achievement.relatedPlaces?.components(separatedBy: " ") else { return }
        for id in list {
            do {
                let uid_ = try PlaceService().readByID(placeID: Int64(id) ?? 0)
                if let uid = uid_ {
                    achievementPlaces.append(uid)
                }
            } catch {
                print(error)
            }
        }
    }
}
