//
//  MapServices.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 11/11/21.
//

import Foundation
import MapKit

class MapServices: NSObject {
    private var mapView: MKMapView!
    private var locationManager = CLLocationManager()
    
    private var listPlaces: [Place] = []
    private let service = PlaceService()
    
    init(_ mapView: MKMapView?) {
        super.init()
        locationManager.delegate = self
        self.mapView = mapView!
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        listPlaces = getPlaces()!
        
    }
    func getPlace(uid: UUID) -> Place? {
        do {
            guard let place = try service.read(uid: uid) else { return nil }
            return place
        } catch {
            print(error)
        }
        return nil
    }
    
    func getPlaces() -> [Place]? {
        do {
            guard let list = try service.readAll() else { return nil }
            return list
        } catch {
            print(error)
        }
        return nil
    }
    
    private func createGeofenceRegion(geofenceRegionCenter: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String) -> CLRegion {
            let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: radius, identifier: identifier)
            geofenceRegion.notifyOnEntry = true
            
            locationManager.startMonitoring(for: geofenceRegion)
        
            return geofenceRegion
    }
    
    private func addCustomAnnotation(place: Place) {
        let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        let pin = CustomAnnotation(uid: place.uid!, state: PlaceState.unknown, coordinate: coordinate)
        
        switch pin.state {
        case PlaceState.known:
            pin.title = place.name
        case PlaceState.onRoute:
            pin.title = "Em rota"
        case PlaceState.unknown:
            pin.title = "Lugar desconhecido"
        }
        
        let uid: String = place.uid!.uuidString
        let region = createGeofenceRegion(geofenceRegionCenter: coordinate, radius: MapConstants.fenceRadius, identifier: uid)
        
        pin.region = region
        
        mapView.addAnnotation(pin)
    }
    
    public func populateMap(){
        for place in listPlaces {
            addCustomAnnotation(place: place)
        }
    }
    
    func displayRoute(sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
           
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = destinationMapItem
        directionsRequest.transportType = .walking // TODO: user choose transport type
        
        let directions = MKDirections(request: directionsRequest)
        
        // remove last route
        mapView.removeOverlays(mapView.overlays)
        
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            }
        }
    }
    
    public func getUserCoordinate2D() -> CLLocationCoordinate2D {
        return locationManager.location?.coordinate ?? MapConstants.unicampCoordinate
    }
    
}

// ref: https://itnext.io/swift-ios-cllocationmanager-all-in-one-b786ffd37e4a
extension MapServices: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied: // Setting option: Never
            print("LocationManager didChangeAuthorization denied")
        case .notDetermined: // Setting option: Ask Next Time
            print("LocationManager didChangeAuthorization notDetermined")
        case .authorizedWhenInUse: // Setting option: While Using the App
            print("LocationManager didChangeAuthorization authorizedWhenInUse")
      
            // Stpe 6: Request a one-time location information
            locationManager.requestLocation()
        case .authorizedAlways: // Setting option: Always
            print("LocationManager didChangeAuthorization authorizedAlways")
      
            // Stpe 6: Request a one-time location information
            locationManager.requestLocation()
        case .restricted: // Restricted by parental control
            print("LocationManager didChangeAuthorization restricted")
        default:
            print("LocationManager didChangeAuthorization")
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager didFailWithError \(error.localizedDescription)")
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            // To prevent forever looping of `didFailWithError` callback
            locationManager.stopMonitoringSignificantLocationChanges()
            return
        }
    }
}
