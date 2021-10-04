//
//  PlacesViewController.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 29/09/21.
//

import Foundation
import UIKit

class PlacesViewController: UIViewController{

    @IBOutlet weak var collectionView: UICollectionView!
    var cellWidth:Double = 0;
    var cellHeight:Double = 0;
    var numberOfCells:Double = 12;
    var lateralEmptySpace:Double = 16 + 16 ;//horizontal distances from safe areas
    var spaceBetweenCells:Double = 8;
    var rows:Double = 2;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lugares"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: (rows == 2 ? "rectangle.grid.1x2.fill" : "rectangle.grid.2x2.fill")), style: .plain , target: self, action: #selector(changeState) )

        
        collectionView.register(PlaceCollectionViewCell.nib(), forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
        cellWidth = (Double(self.view.frame.size.width) - lateralEmptySpace) / rows - spaceBetweenCells
        cellHeight = cellWidth * 0.7
        
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.setContentOffset(.zero, animated: false)
        
    }
    @objc func changeState(sender: UIButton!) {
        rows = 3 - rows
        self.viewDidLoad()
    }
}


extension PlacesViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("You tapped me",indexPath)
    }
}
extension PlacesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceCollectionViewCell.identifier, for: indexPath) as! PlaceCollectionViewCell
        //Tratar caso de imagem nao carregar
        
        cell.configure(with: UIImage(named: "Unicamp_PB")! )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(numberOfCells)
    }
}

extension PlacesViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth ,height: cellHeight)
    }
    
}


