//
//  MapViewController.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 29/09/21.
//  Controller for Map Screen

import MapKit
import CoreLocation
import UIKit
import CoreData

extension MKMapView {
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

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //public var location: CLLocationCoordinate2D?
    
    private var mapServices: MapServices!
    private var placeService = PlaceService()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.background
        title = "Mapa"
        setupMapView()
        definesPresentationContext = true
        (UIApplication.shared.delegate as! AppDelegate).annotationDelegate = self
        mapServices = MapServices(mapView)
        mapServices.populateMap()
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        let initialLocation = MapConstants.unicamp
        mapView.centerToLocation(initialLocation)
        mapView.tintColor = Color.pink
        mapView.pointOfInterestFilter = .excludingAll
    }
    override func viewDidAppear(_ animated: Bool) {
        mapServices.populateMap()
        if ((UIApplication.shared.delegate as! AppDelegate).clickedLocation != nil){
            self.mapView.centerToLocation(CLLocation(latitude: (UIApplication.shared.delegate as! AppDelegate).clickedLocation!.latitude, longitude: (UIApplication.shared.delegate as! AppDelegate).clickedLocation!.longitude))
        }
    }
}


// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            //Create the view
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let currentAnnotation = annotationView?.annotation as! CustomAnnotation
        
        switch currentAnnotation.state {
        case .unknown:
            annotationView?.image = UIImage(named: "unknown-pin-purple")
        case .known:
            annotationView?.image = UIImage(named: "known-pin-green")
        case .onRoute:
            annotationView?.image = UIImage(named: "unknown-pin-orange")
        }

        annotationView?.frame.size = CGSize(width: MapConstants.annotationWidth, height: MapConstants.annotationHeight)
        let btn = UIButton(type: .detailDisclosure )
        btn.setImage( UIImage(systemName: "chevron.right"), for: .normal)
        btn.tintColor = Color.pink
        annotationView?.rightCalloutAccessoryView = btn
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // do something
        view.frame.size = CGSize(width: MapConstants.selectedAnnitationWidht, height: MapConstants.selectedAnnotationHeight)
        view.centerOffset = .zero
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.frame.size = CGSize(width: MapConstants.annotationWidth, height: MapConstants.annotationHeight)
        })
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "placeDetails", sender: view.annotation)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = MapConstants.routeLineWidth
        renderer.strokeColor = Color.pink
        
        return renderer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeDetails" {
            if let destVC = segue.destination as? PlaceViewController,
               let annotation = sender as? CustomAnnotation {
                destVC.place = mapServices.getPlace(uid: annotation.uid)!
                destVC.userCoordinate = mapServices.getUserCoordinate2D()
                destVC.annotation = annotation
                destVC.routeDelegate = self
                destVC.annotationDelegate = self
            }
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: RouteDelegate {
    func didTapGo(destinationCoordinate: CLLocationCoordinate2D) {
        mapServices.displayRoute(sourceCoordinate: mapServices.getUserCoordinate2D(),
                                 destinationCoordinate: destinationCoordinate)
    }
    
    func didTapLocation(locationCoordinate: CLLocationCoordinate2D) {
        (UIApplication.shared.delegate as! AppDelegate).clickedLocation = locationCoordinate
        self.mapView.setCenter(locationCoordinate, animated: true)
    }
}

extension MapViewController: AnnotationDelegate {
    func updateAnnotations(){
        for annotation in mapView.annotations {
            DispatchQueue.main.async {
                if let annotation = annotation as? CustomAnnotation {
                    self.updateAnnotation(annotation: annotation)
                } else {
                    print(annotation)
                }
                
            }
        }
    }
    
    func updateAnnotation(annotation: CustomAnnotation) {
        mapView.removeAnnotation(annotation)
        let uid = annotation.uid
        let place = try! placeService.read(uid: uid)
        mapServices.addCustomAnnotation(place: place!)
    }
}
