//
//  Adress.swift
//  campus-go
//
//  Created by Giordano Mattiello on 05/10/21.
//

import Foundation


struct Address: Hashable,Decodable,Identifiable{
    init(){
        zipCode = ""
        city = ""
        street = ""
        state = ""
        country = ""
        stateAbbr = ""
        block = ""
    }
    
    var id: UUID{
        UUID()
    }
    var zipCode:String
    var city:String
    var street:String
    var state:String
    var country:String
    var stateAbbr:String
    var block:String
    
    
}
