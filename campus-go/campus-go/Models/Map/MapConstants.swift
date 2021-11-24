//
//  MapConstants.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 04/10/21.
//

import Foundation
import CoreLocation

struct MapConstants {
    
    static let unicamp = CLLocation(latitude: -22.8184, longitude:  -47.0647)
    static let unicampCoordinate = CLLocationCoordinate2D(latitude: -22.8184, longitude:  -47.0647)
    static let cbCoordinate =  CLLocationCoordinate2D(latitude: -22.817029, longitude:  -47.069759)
    static let pracaPazCoordinate = CLLocationCoordinate2D(latitude: -22.822403, longitude:  -47.067731)
    
    static let initialRegionRadius: CLLocationDistance = 1500
    
    static let resultsTableViewNumberOfSections = 1
    
    static let routeLineWidth = 5.0
    
    static let annotationHeight: Double = 30
    static let annotationWidth: Double = 18
    static let selectedAnnotationHeight: Double = 60
    static let selectedAnnitationWidht: Double = 36
    
    static let fenceRadius: Double = 10
}
