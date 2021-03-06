//
//  AchievementCollectionViewCell.swift
//  campus-go
//
//  Created by Giordano Mattiello on 12/11/21.
//

import UIKit

class AchievementCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var progressView: AchievementProgressView!
    @IBOutlet weak var stackLabels: UIStackView!
    @IBOutlet weak var chevron: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var objective: UILabel!
//    @IBOutlet weak var progress: UILabel!
    public var uid: UUID?
    
    
    static let identifier = "AchievementCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.chevron.tintColor = UIColor.systemGray3
    }
    //
    public func configure(achievement: Achievement){
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.borderWidth = 0.5
        self.uid = achievement.uid
        self.name.text = achievement.name
        self.progressLabel.text = "\(Int(achievement.progress*100))% concluída"
        self.objective.text = achievement.objective
        if(achievement.progress==0.0) {
            progressLabel.isHidden = true
        }
        self.progressView.achievementImage.image = UIImage(named: "A-\(achievement.achievementID)")
        self.progressView.setProgress(progress: achievement.progress)
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "AchievementCollectionViewCell",bundle: nil )
    }

}
