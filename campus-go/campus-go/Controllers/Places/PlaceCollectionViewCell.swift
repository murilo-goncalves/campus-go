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
    public func configure(with image: UIImage,status: PlaceCellStatus , screenState: PlaceScreenState){
        
        self.layer.cornerRadius = imageView.frame.width * 0.05
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        mapPin.image = mapPin.image?.withRenderingMode(.alwaysTemplate)
        
        
        
        if(status == PlaceCellStatus.known){
            imageView.image = image
            mapPin.isHidden = true
            label.text = screenState == PlaceScreenState.small ? "" : "Nome do lugar"
            bottomColor.backgroundColor = Color.lightGreen
            
        } else if(status == PlaceCellStatus.unknown){
            imageView.image = image.convertToGrayScale()
            mapPin.isHidden = false
            label.text = screenState == PlaceScreenState.small ? "" : "Desconhecido"
            mapPin.image = UIImage(named: "unknown-pin-soft-purple")
            bottomColor.backgroundColor = Color.lightPurple
            
        } else {
            imageView.image = image.convertToGrayScale()
            mapPin.isHidden = false
            label.text = screenState == PlaceScreenState.small ? "" : "Em rota"
            mapPin.image =  UIImage(named: "unknown-pin-soft-orange")
            bottomColor.backgroundColor = Color.lightOrange
        }
    }
    static func nib() -> UINib{
        return UINib(nibName: "PlaceCollectionViewCell",bundle: nil )
    }
}


