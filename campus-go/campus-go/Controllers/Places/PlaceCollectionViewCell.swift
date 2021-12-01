//
//  PlaceCollectionViewCell.swift
//  campus-go
//
//  Created by Giordano Mattiello on 01/10/21.
//

import UIKit

class PlaceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mapPin: UIImageView!
    @IBOutlet weak var bottomColor: UIView!
    
    static let identifier = "PlaceCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    public func configure(screenState: PlaceScreenState,place: Place){
        self.layer.cornerRadius = imageView.frame.width * 0.05
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        mapPin.image = mapPin.image?.withRenderingMode(.alwaysTemplate)
        let status = PlaceState(rawValue: Int(place.state))
        if(status == PlaceState.known){
            imageView.image = UIImage(named: String(place.placeID) + "-1")
            mapPin.isHidden = true
            label.text = screenState == PlaceScreenState.small ? "" : place.name
            bottomColor.backgroundColor = Color.lightGreen
            

        } else if(status == PlaceState.unknown){
            imageView.image = UIImage(named: String(place.placeID) + "-1")!.convertToGrayScale()

            mapPin.isHidden = false
            label.text = screenState == PlaceScreenState.small ? "" : "Desconhecido"
            mapPin.image = UIImage(named: "unknown-pin-soft-purple")
            bottomColor.backgroundColor = Color.lightPurple
            
        } else {
            imageView.image = UIImage(named: String(place.placeID) + "-1")!.convertToGrayScale()
            mapPin.isHidden = false
            label.text = screenState == PlaceScreenState.small ? "" : "Em rota"
            mapPin.image =  UIImage(named: "on-route-soft")
            bottomColor.backgroundColor = Color.lightOrange
        }
    }
    static func nib() -> UINib{
        return UINib(nibName: "PlaceCollectionViewCell",bundle: nil )
    }
}


