//
//  Pictures.swift
//  campus-go
//
//  Created by Luiz Gustavo Silva Aguiar on 17/11/21.
//

import Foundation

struct Pictures {
    var numberOfPictures = 11
    var listPictures: [[String]]
    
    init(){
        listPictures = Array(repeating: [String](), count: numberOfPictures)
        for i in 1...10 {
            for j in 1...3 {
                listPictures[i].append("\(i)-\(j)")
            }
        }
        print(listPictures)
    }
}
