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
        let achievementId = Int64(4) // id da conquista de desbloquear primeiro lugar
        let achievementUid = try! achievementService.retrieve(achievementID: achievementId)
        let achievement = try! achievementService.retrieve(uid: achievementUid!)
        if (achievement?.progress == 1.0) { return nil }
        if (userAttributes.getUserPlaces() == 1) {
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
        
        return validatedAchievements
    }
}
