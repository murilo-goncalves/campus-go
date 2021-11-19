//
//  AchievementCollectionViewCell.swift
//  campus-go
//
//  Created by Giordano Mattiello on 12/11/21.
//

import UIKit

class AchievementCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var progress: AchievementProgressView!
    @IBOutlet weak var stackLabels: UIStackView!
    @IBOutlet weak var chevron: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    
    static let identifier = "AchievementCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(hasProgress: Bool){
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.borderWidth = 0.5
        if(!hasProgress){
            progressLabel.removeFromSuperview()
        }
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "AchievementCollectionViewCell",bundle: nil )
    }

}
