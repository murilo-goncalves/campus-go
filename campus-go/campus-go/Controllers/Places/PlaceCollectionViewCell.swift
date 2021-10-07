//
//  PlaceCollectionViewCell.swift
//  campus-go
//
//  Created by Giordano Mattiello on 01/10/21.
//

import UIKit

class PlaceCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var mapFlagImage: UIImageView!
    
    
    static let identifier = "PlaceCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    public func configure(with image: UIImage,isVisited: Bool){
        
        self.layer.cornerRadius = imageView.frame.width * 0.05
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        if(isVisited){
            imageView.image = image
            mapFlagImage.isHidden = true
        }else{
            imageView.image = image.convertToGrayScale()
            mapFlagImage.isHidden = false
        }

    }
    static func nib() -> UINib{
        return UINib(nibName: "PlaceCollectionViewCell",bundle: nil )
    }
}


