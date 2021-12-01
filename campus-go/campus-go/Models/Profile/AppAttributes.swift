//
//  AppAttributes.swift
//  campus-go
//
//  Created by Luiz Gustavo Silva Aguiar on 01/12/21.
//

import Foundation

struct AppAttributes {
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
    
    func getAllXP() -> Int {
        let listPlaces = readPlaces() ?? []
        let listAchievements = readAchievements() ?? []
        var xp = listPlaces.count * placeDefaultXP
        for ac in listAchievements {
            xp += Int(ac.xpPoints)
        }
        return xp
    }
    func getAllAchievements() -> Int {
        let listAchievements = readAchievements() ?? []
        return listAchievements.count
    }
    func getAllPlaces() -> Int {
        let listPlaces = readPlaces() ?? []
        return listPlaces.count
    }
}
