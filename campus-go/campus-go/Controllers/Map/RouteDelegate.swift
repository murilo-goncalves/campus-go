//
//  RouteDelegate.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 11/11/21.
//

import Foundation
import CoreLocation

protocol RouteDelegate {
    func didTapGo(destinationCoordinate: CLLocationCoordinate2D)
}
