//
//  ManageProgress.swift
//  campus-go
//
//  Created by Luiz Gustavo Silva Aguiar on 07/12/21.
//

import Foundation

struct ManageProgress {
    let achievementService = AchievementService()
    let placeService = PlaceService()
    
    func calculateNewProgress(_ achievement: Achievement) -> Double {
        let uuidPlaces = RelatedPlaces(achievement).achievementPlaces
        let places = placeService.retrieveByUUIDs(uuids: uuidPlaces)
        var sumVisits = 0
        for place in places {
            sumVisits += Int(place.nVisits)
        }
        var newProgress = Double(sumVisits)/Double(achievement.nVisits)
        formataProgress(&newProgress)
        return newProgress
    }
    func formataProgress(_ progress: inout Double) {
        progress = (progress*10).rounded()/10
    }
    
    func update(achievement: Achievement) -> Achievement {
        let newProgress = calculateNewProgress(achievement)
        if newProgress <= achievement.progress { return  achievement}
        do {
            try achievementService.updateProgress(uid: achievement.uid!, progress: newProgress)
        } catch {
            print(error)
        }
        return achievement
    }
    
    
}
