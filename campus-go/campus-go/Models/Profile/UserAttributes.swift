//
//  UserAttributes.swift
//  campus-go
//
//  Created by Luiz Gustavo Silva Aguiar on 30/11/21.
//

import Foundation

struct UserAttributes {
    let placeService = PlaceService()
    let achievementService = AchievementService()
    let placeDefaultXP = 20
    
    func readPlaces() -> [Place]? {
        do {
            guard let listPlaces = try placeService.readAll() else { return nil }
            return listPlaces
        } catch {
            print(error)
        }
        return nil
    }
    
    func readAchievements() -> [Achievement]? {
        do {
            guard let listAchievements = try achievementService.retrieve() else { return nil}
            return listAchievements
        } catch {
            print(error)
        }
        return nil
    }
    
    func getUserXP() -> Int {
        let listPlaces = readPlaces() ?? []
        let listAchievements = readAchievements() ?? []
        var userXP = 0
        for place in listPlaces {
            if(place.state == PlaceState.known.rawValue) {
                userXP+=placeDefaultXP
            }
        }
        for ac in listAchievements {
            if(ac.progress == 1.0) {
                userXP += Int(ac.xpPoints)
            }
        }
        return userXP
    }
    func getUserAchievements() -> Int {
        let listAchievements = readAchievements() ?? []
        var cnt = 0
        for ac in listAchievements {
            if(ac.progress == 1.0) {
                cnt+=1
            }
        }
        return cnt
    }
    func getUserPlaces() -> Int {
        let listPlaces = readPlaces() ?? []
        var cnt = 0
        for place in listPlaces {
            if(place.state == PlaceState.known.rawValue) {
                cnt+=1
            }
        }
        return cnt
    }
}
