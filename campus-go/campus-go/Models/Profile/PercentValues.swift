//
//  ProgressValues.swift
//  campus-go
//
//  Created by Luiz Gustavo Silva Aguiar on 01/12/21.
//

import Foundation

struct PercentValues {
    static func getPercentualXP() -> Double {
        let percent = Double(UserAttributes().getUserXP())/Double(AppAttributes().getAllXP())
        return (percent*100).rounded()/100
    }
    static func getPercentualPlaces() -> Double {
        let percent = Double(UserAttributes().getUserPlaces())/Double(AppAttributes().getAllPlaces())
        return (percent*100).rounded()/100
    }
    static func getPercentualAchievements() -> Double {
        let percent = Double(UserAttributes().getUserAchievements())/Double(AppAttributes().getAllAchievements())
        return (percent*100).rounded()/100
    }
}
