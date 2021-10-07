//
//  MapViewController.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 29/09/21.
//  Controller for Map Screen

import MapKit
import CoreLocation

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

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var topView: UIView!
    
    private var searchController: UISearchController!
    private var resultsTableViewController: ResultsTableViewController!
    
    private let searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupMapView()
        setupResultsTableView()
        setupSearchController()
        definesPresentationContext = true
        searchCompleter.delegate = self
        
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
