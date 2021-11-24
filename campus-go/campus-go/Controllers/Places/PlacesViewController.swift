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
    private var cellWidth:Double = 0
    private var cellHeight:Double = 0
    private var state:PlaceScreenState = PlaceScreenState.large // initial view state with small cells
    
    //MARK: constants
    private let lateralEmptySpace:Double = 32//horizontal distances to safe area
    private let spaceBetweenCells:Double = 8//space between cells
    private let navBarButtonImages = [1: "rectangle.grid.2x2.fill",2 :"rectangle.grid.1x2.fill"] //navbar right button image names
    
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

        collectionView.register(PlaceCollectionViewCell.nib(), forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(rgb: 0xF2F2F7)
        self.view.backgroundColor = UIColor(rgb: 0xF2F2F7)
        updateCollectionViewLayout()
    }
    
    private func updateCollectionViewLayout(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: navBarButtonImages[state.rawValue] ?? ""), style: .plain , target: self, action: #selector(changeState) )
        navigationItem.rightBarButtonItem?.tintColor = Color.pink
        
        cellWidth = (Double(self.view.frame.size.width) - lateralEmptySpace) / Double(state.rawValue) - spaceBetweenCells
        cellHeight = cellWidth * 0.7
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.setContentOffset(CGPoint(x: 0,y:-1), animated: false)
        collectionView.reloadData()
    }
    
    @objc func changeState(sender: UIButton!) {
        if(state == PlaceScreenState.small){
            state = PlaceScreenState.large
        } else {
            state = PlaceScreenState.small
        }
        UIView.animate(withDuration: 0.2) {
            self.updateCollectionViewLayout()
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
    override func viewDidAppear(_ animated: Bool) {
        sortPlaces()
        self.collectionView.reloadData()
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


