//
//  RelatedPlaces.swift
//  campus-go
//
//  Created by Luiz Gustavo Silva Aguiar on 06/12/21.
//

import Foundation

struct RelatedPlaces {
    var achievementPlaces: [UUID] = []
    init(_ achievement: Achievement) {
        guard let list = achievement.relatedPlaces?.components(separatedBy: " ") else { return }
        //Não existe lugar relacionado a esta conquista
        if list[0] == "None" {
            return
        }
        //Todos os lugares estão relacionados a esta conquista
        else if list[0] == "All" {
            do {
                guard let places = try PlaceService().readAll() else { return }
                for place in places {
                    achievementPlaces.append(place.uid!)
                }
            } catch {
                print(error)
            }
        }
        //busca os lugares relacionados
        else {
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
}
