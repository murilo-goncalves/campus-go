//
//  CustomAnnotation.swift
//  campus-go
//
//  Created by Luiz Gustavo Silva Aguiar on 16/11/21.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var uid: UUID
    var title: String?
    var state: PlaceState
    @objc dynamic var coordinate: CLLocationCoordinate2D
    init(uid: UUID, state: PlaceState, coordinate: CLLocationCoordinate2D) {
        self.uid = uid
        self.state = state
        self.coordinate = coordinate
    }
    
}
