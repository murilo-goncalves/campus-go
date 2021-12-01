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
    
    
    private var mapServices: MapServices!
    private var placeService = PlaceService()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.background
        title = "Mapa"
        setupMapView()
        definesPresentationContext = true
        (UIApplication.shared.delegate as! AppDelegate).annotationDelegate = self
        (UIApplication.shared.delegate as! AppDelegate).routeDelegate = self
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
        do {
            if let onRoutePlace = try placeService.readOnRoute() {
                let destinationCoordinate = CLLocationCoordinate2D(latitude: onRoutePlace.latitude, longitude: onRoutePlace.longitude)
                let sourceCoordinate = mapServices.getUserCoordinate2D()
                mapServices.displayRoute(sourceCoordinate: sourceCoordinate, destinationCoordinate: destinationCoordinate)
            } else {
                mapServices.removeRoute()
            }
        } catch {
            print(error)
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
            annotationView?.image = UIImage(named: "on-route")
        }

        annotationView?.frame.size = CGSize(width: MapConstants.annotationWidth, height: MapConstants.annotationHeight)
        let btn = UIButton(type: .detailDisclosure )
        btn.setImage( UIImage(systemName: "chevron.right"), for: .normal)
        btn.tintColor = Color.pink
        annotationView?.rightCalloutAccessoryView = btn
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.transform = CGAffineTransform.identity
        view.detailCalloutAccessoryView?.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = view.transform.scaledBy(x: 1.2, y: 1.2)
        })

    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped: UIControl){
        
    }

            

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = CGAffineTransform.identity
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
    func didTapGo() {
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
    }
    
    func didTapLocation(locationCoordinate: CLLocationCoordinate2D) {
        (UIApplication.shared.delegate as! AppDelegate).clickedLocation = locationCoordinate
        mapView.setCenter(locationCoordinate, animated: true)
    }
    
    func didTapCancel() {
        mapServices.removeRoute()
        mapView.setUserTrackingMode(.none, animated: true)
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

extension MapViewController: AlertViewDelegate{
    func goToDetails(place: Place) {
        let storyboard = UIStoryboard(name: "Place", bundle: nil)
        if let placeViewController = storyboard.instantiateViewController(withIdentifier: "PlaceDetails") as? PlaceViewController{
            placeViewController.place = place
            self.navigationController?.pushViewController(placeViewController, animated: true)
        }
    }
}
