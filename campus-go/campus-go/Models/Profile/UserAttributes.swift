//
//  UserAttributes.swift
//  campus-go
//
//  Created by Luiz Gustavo Silva Aguiar on 30/11/21.
//

import Foundation

struct UserAttributes {
    var userXP: Int = 0
    var allXP: Int = 1
    var userNumberAchievements: Int = 0
    var allNumberAchievements: Int = 1
    var userNumberPlaces: Int = 0
    var allNumberPlaces: Int = 1
    
    var placeService = PlaceService()
    var achievementService = AchievementService()
    
    init() {
        do {
            if let achievements = try achievementService.retrieve() {
                for ac in achievements {
                    allXP += Int(ac.xpPoints)
                    if(ac.progress == 1.0) {
                        userXP += Int(ac.xpPoints)
                        userNumberAchievements += 1
                    }
                }
                allNumberAchievements = achievements.count
            }
        } catch {
            print(error)
        }
        
        do {
            if let places = try placeService.readAll() {
                for place in places {
                    if (place.state == PlaceState.known.rawValue) {
                        userNumberPlaces += 1
                    }
                }
                allNumberPlaces = places.count
            }
        } catch {
            print(error)
        }
    }
    
    func getPercentualXP() -> Double {
        let percent = Double(userXP)/Double(allXP)
        return (percent*100).rounded()/100
    }
    func getPercentualPlaces() -> Double {
        let percent = Double(userNumberPlaces)/Double(allNumberPlaces)
        return (percent*100).rounded()/100
    }
    func getPercentualAchievements() -> Double {
        let percent = Double(userNumberAchievements)/Double(allNumberAchievements)
        return (percent*100).rounded()/100
    }
}
