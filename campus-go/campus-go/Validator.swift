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
    let manageProgress = ManageProgress()
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
    
    private func validateMidPlaces() -> Achievement? {
        let achievementId = Int64(13) // id da conquista de desbloquear primeiro lugar
        let achievementUid = try! achievementService.retrieve(achievementID: achievementId)
        let achievement = try! achievementService.retrieve(uid: achievementUid!)
        if (achievement?.progress == 1.0) { return nil }
        var newProgress = Double(userAttributes.getUserPlaces())/5.0
        manageProgress.formataProgress(&newProgress)
        try! achievementService.updateProgress(uid: achievementUid!, progress: newProgress)
        if(newProgress != 1.0) { return nil }
        return achievement
    }
    
    private func validateAllPlaces() -> Achievement? {
        let achievementId = Int64(14) // id da conquista de desbloquear primeiro lugar
        let achievementUid = try! achievementService.retrieve(achievementID: achievementId)
        let achievement = try! achievementService.retrieve(uid: achievementUid!)
        if (achievement?.progress == 1.0) { return nil }
        var newProgress = Double(userAttributes.getUserPlaces())/15.0
        manageProgress.formataProgress(&newProgress)
        try! achievementService.updateProgress(uid: achievementUid!, progress: newProgress)
        if(newProgress != 1.0) { return nil }
        return achievement
    }
    //Retorna 1 se conquistou o achievement e 0 se ele já foi conquistado ou só atualizou o estado
    private func validateAchievementWithVisits(_ achievement: Achievement) -> Achievement? {
        let achievementUpdated = manageProgress.update(achievement: achievement)
        if(achievementUpdated.progress == 1.0) {
            return achievementUpdated
        } else {
            return nil
        }
    }
    private func validateAchievementsWithVisits(_ place: Place) -> [Achievement] {
        //Pega os uuids de todos os achievements relacionados a este lugar
        let uuids = RelatedAchievements(place).placeAchievements
        //possiveis achievements a serem validados
        let possibleAchievements = achievementService.retrieveByUUIDs(uuids: uuids)
        var achievements: [Achievement] = []
        for _ac in possibleAchievements {
            if _ac.progress == 1.0 || _ac.relatedPlaces == "None" { continue }
            if let ac = validateAchievementWithVisits(_ac) {
                achievements.append(ac)
            }
        }
        return achievements
    }
    //Valida ao chegar em um lugar
    func didValidate(place: Place) -> [Achievement] {
        var validatedAchievements = [Achievement]()
        if let achievement = validateFirstPlace() {
            validatedAchievements.append(achievement)
        }
        
        if let achievement = validateMidPlaces() {
            validatedAchievements.append(achievement)
        }
        
        if let achievement = validateAllPlaces() {
            validatedAchievements.append(achievement)
        }
        
        for achievement in validateAchievementsWithVisits(place) {
            validatedAchievements.append(achievement)
        }
        
        return validatedAchievements
    }
}
