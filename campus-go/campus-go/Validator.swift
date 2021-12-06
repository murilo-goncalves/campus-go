//
//  Validator.swift
//  campus-go
//
//  Created by Luiz Gustavo Silva Aguiar on 03/12/21.
//

import Foundation

class Validator {
    let userAttributes = UserAttributes()
    let achievementService = AchievementService()
    
    private func validateFirstPlace() -> Achievement? {
        let achievementId = Int64(12) // id da conquista de desbloquear primeiro lugar
        let achievementUid = try! achievementService.retrieve(achievementID: achievementId)
        let achievement = try! achievementService.retrieve(uid: achievementUid!)
        if (achievement?.progress == 1.0) { return nil }
        if (userAttributes.getUserPlaces() == 1) {
            try! achievementService.updateProgress(uid: achievementUid!, progress: 1.0)
            return achievement
        }
        return nil
    }
    private func validateAllPlaces() -> Achievement? {
        let achievementId = Int64(14) // id da conquista de desbloquear primeiro lugar
        let achievementUid = try! achievementService.retrieve(achievementID: achievementId)
        let achievement = try! achievementService.retrieve(uid: achievementUid!)
        if (achievement?.progress == 1.0) { return nil }
        if (userAttributes.getUserPlaces() == 15) {
            try! achievementService.updateProgress(uid: achievementUid!, progress: 1.0)
            return achievement
        }
        return nil
    }
    
    func didValidate() -> [Achievement] {
        var validatedAchievements = [Achievement]()
        if let achievement = validateFirstPlace() {
            validatedAchievements.append(achievement)
        }
        
        if let achievement = validateAllPlaces() {
            validatedAchievements.append(achievement)
        }
        return validatedAchievements
    }
}
