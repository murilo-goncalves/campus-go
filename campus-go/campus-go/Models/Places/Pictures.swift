//
//  Pictures.swift
//  campus-go
//
//  Created by Luiz Gustavo Silva Aguiar on 17/11/21.
//

import Foundation

struct Pictures {
    var numberOfPictures: Int
    var listPictures: [String]
    
    init(placeID: Int, numberOfPictures: Int){
        listPictures = [String]()
        self.numberOfPictures = numberOfPictures
        for i in 1...numberOfPictures {
            self.listPictures.append("\(placeID)-\(i)")
        }
    }
    init(achievementID: Int) {
        listPictures = [String]()
        listPictures.append("A-\(achievementID)")
        numberOfPictures = 1
    }
    init(){
        numberOfPictures = 0
        listPictures = []
    }
}
