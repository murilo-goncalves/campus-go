//
//  MapViewController.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 29/09/21.
//

import Foundation
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        
        let initialLocation = MapConstants.unicamp
        mapView.centerToLocation(initialLocation)
        
    }
    
    func setupLocationManager() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        locationManager = appDelegate.locationManager
        locationManager.delegate = self
    }
}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = MapConstants.initialRegionRadius
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        setRegion(coordinateRegion, animated: true)
    }
}
