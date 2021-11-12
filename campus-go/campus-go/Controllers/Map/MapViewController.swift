//
//  MapViewController.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 29/09/21.
//  Controller for Map Screen

import MapKit
import CoreLocation
import UIKit

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
    @IBOutlet weak var topView: UIView!
    
    private var searchController: UISearchController!
    private var resultsTableViewController: ResultsTableViewController!
    
    private let searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    private var mapServices: MapServices!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupResultsTableView()
        setupSearchController()
        definesPresentationContext = true
        searchCompleter.delegate = self
        title = "mapas"
        
        addCustomPin(coordinate: CLLocationCoordinate2D(latitude: -22.822403, longitude:  -47.067731))
        addCustomPin(coordinate: CLLocationCoordinate2D(latitude: -22.817029, longitude:  -47.069759))
        
        mapServices = MapServices(mapView)
    }
    
    private func addCustomPin(coordinate: CLLocationCoordinate2D){
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Lugar desconhecido"
        pin.subtitle = "Visitar o lugar"
        mapView.addAnnotation(pin)
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        let initialLocation = MapConstants.unicamp
        mapView.centerToLocation(initialLocation)
    }
    
    private func setupResultsTableView() {
        resultsTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultsTableViewController") as? ResultsTableViewController
        resultsTableViewController?.delegate = self
        
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: resultsTableViewController)
        searchController.searchResultsUpdater = resultsTableViewController
        searchController.searchBar.delegate = self
        topView.addSubview(searchController.searchBar)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.frame.size.width = topView.frame.size.width
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = Color.pink
    }
}

// MARK: - UITableViewDelegate

extension MapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        print(indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension MapViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return MapConstants.resultsTableViewNumberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension MapViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
        
    }
    
}

// MARK: - MKLocalSearchCompleterDelegate

extension MapViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        searchResults = completer.results
        resultsTableViewController.tableView.reloadData()
        
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
    
}

// MARK: - ResultsTableViewDelegate

extension MapViewController: ResultsTableViewDelegate {
    
    func setup(resultsTableViewController: ResultsTableViewController?) {
        resultsTableViewController?.tableView.delegate = self
        resultsTableViewController?.tableView.dataSource = self
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
        annotationView?.image = UIImage(named: "unknown-pin-purple")
        annotationView?.frame.size = CGSize(width: 18, height: 30)
        let btn = UIButton(type: .detailDisclosure )
        btn.setImage( UIImage(systemName: "chevron.right"), for: .normal)
        btn.tintColor = Color.pink
        annotationView?.rightCalloutAccessoryView = btn
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // do something
        view.frame.size = CGSize(width: 36, height: 60)
        view.centerOffset = .zero
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.frame.size = CGSize(width: 18, height: 30)
        })
    }
    

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "placeDetails", sender: view.annotation)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5.0
        renderer.strokeColor = Color.pink
        
        return renderer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeDetails" {
            if let destVC = segue.destination as? PlaceViewController,
               let annotation = sender as? MKAnnotation {
                destVC.placeCoordinate = annotation.coordinate
                destVC.routeDelegate = self
            }
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: RouteDelegate {
    func didTapGo(destinationCoordinate: CLLocationCoordinate2D) {
        let userCoordinate = mapServices.getUserCoordinate2D()
        mapServices.displayRoute(sourceCoordinate: userCoordinate, destinationCoordinate: destinationCoordinate)
    }
}
