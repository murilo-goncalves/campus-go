//
//  PlaceCollectionViewCell.swift
//  campus-go
//
//  Created by Giordano Mattiello on 01/10/21.
//

import UIKit

class PlaceCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    
    static let identifier = "PlaceCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    public func configure(with image: UIImage){
        imageView.image = image
        self.layer.cornerRadius = imageView.frame.width * 0.05
       
        self.layer.borderWidth = 1
    }
    static func nib() -> UINib{
        return UINib(nibName: "PlaceCollectionViewCell",bundle: nil )
    }
}
