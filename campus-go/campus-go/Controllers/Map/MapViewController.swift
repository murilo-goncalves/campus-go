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
        
        addCustomPin(coordinate: MapConstants.pracaPazCoordinate)
        addCustomPin(coordinate: MapConstants.cbCoordinate)
        
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
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Place", bundle: nil)
        let destVc = storyboard.instantiateViewController(withIdentifier: "PlaceDetails") as! PlaceViewController

        destVc.modalPresentationStyle = UIModalPresentationStyle.automatic
        destVc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        
        destVc.placeCoordinate = view.annotation?.coordinate
        destVc.routeDelegate = self
        
        present(destVc, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = MapConstants.routeLineWidth
        renderer.strokeColor = Color.pink
        
        return renderer
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: RouteDelegate {
    func didTapGo(destinationCoordinate: CLLocationCoordinate2D) {
        let userCoordinate = mapServices.getUserCoordinate2D()
        mapServices.displayRoute(sourceCoordinate: userCoordinate, destinationCoordinate: destinationCoordinate)
    }
}
