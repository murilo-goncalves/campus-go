//
//  RelatedAchievements.swift
//  campus-go
//
//  Created by Luiz Gustavo Silva Aguiar on 27/11/21.
//

import Foundation

struct RelatedAchievements {
    var placeAchievements: [UUID] = []
    init(place: Place) {
        guard let list = place.relatedAchievements?.components(separatedBy: " ") else { return }
        for id in list {
            do {
                let uid_ = try AchievementService().retrieve(achievementID: Int64(id) ?? 0)
                if let uid = uid_ {
                    placeAchievements.append(uid)
                }
            } catch {
                print(error)
            }
        }
    }
}
