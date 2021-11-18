//
//  PlacesViewController.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 29/09/21.
//

import Foundation
import UIKit
import CoreLocation

class PlacesViewController: UIViewController{

    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: variables calculated in viewDidLoad
    var cellWidth:Double = 0;
    var cellHeight:Double = 0;
    var state:PlaceScreenState = PlaceScreenState.small; // initial view state with small cells
    
    //MARK: constants
    let lateralEmptySpace:Double = 32 ;//horizontal distances to safe area
    let spaceBetweenCells:Double = 8; //space between cells
    let navBarButtonImages = [1: "rectangle.grid.2x2.fill",2 :"rectangle.grid.1x2.fill"] //navbar right button image names
    
    //MARK: constants to be deleted
    let numberOfCells:Double = 12;
    private let service = PlaceService()
    
    private var places:[Place] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lugares"
        
        do {
            places = try service.readAll()!
            sortPlaces()
        } catch {
            print(error)
        }

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: navBarButtonImages[state.rawValue] ?? ""), style: .plain , target: self, action: #selector(changeState) )
        navigationItem.rightBarButtonItem?.tintColor = Color.pink
        
        collectionView.register(PlaceCollectionViewCell.nib(), forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        cellWidth = (Double(self.view.frame.size.width) - lateralEmptySpace) / Double(state.rawValue) - spaceBetweenCells
        cellHeight = cellWidth * 0.7
        
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.setContentOffset(CGPoint(x: 0,y:-1), animated: false)
    }
    
    @objc func changeState(sender: UIButton!) {
        if(state == PlaceScreenState.small){
            state = PlaceScreenState.large
        }else if(state == PlaceScreenState.large){
            state = PlaceScreenState.small
        }
        for i in stride(from: 0,to: Int(numberOfCells), by:1) {
            collectionView.reloadItems(at: [IndexPath(item: i, section: 0)])
        }
        
        UIView.animate(withDuration: 0.2) {
            self.viewDidLoad()
        }
        
    }
    
    func sortPlaces(){
        places.sort(by: {
            if $0.state == $1.state {
                return $0.name! < $1.name!
            }
            return $0.state > $1.state
        })
    }
    
}


extension PlacesViewController: UICollectionViewDelegate{
    // MARK: UICollectionViewDelegate methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "placeDetails", sender: places[indexPath.item] )
        collectionView.deselectItem(at: indexPath, animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeDetails", let dest = segue.destination as? PlaceViewController, let place = sender as? Place {
            dest.place = place
            dest.placeCoordinate = CLLocationCoordinate2D.init(latitude: place.latitude, longitude: place.longitude)
        }
    }
}


extension PlacesViewController: UICollectionViewDataSource{
    // MARK: UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceCollectionViewCell.identifier,
                                                      for: indexPath) as! PlaceCollectionViewCell
        
        cell.configure(screenState: state,place: places[indexPath.item] )
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(places.count)
    }
    
}


extension PlacesViewController: UICollectionViewDelegateFlowLayout{
    // MARK: UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth ,height: cellHeight)
    }
    
}


