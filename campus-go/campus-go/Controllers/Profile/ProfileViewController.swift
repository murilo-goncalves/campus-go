//
//  ProfileViewController.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 29/09/21.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileView: ProfileView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProfileTitle()
        setProgressView()
        profileView.profileProgressView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        profileView.recentAchievementView.layer.borderColor = UIColor.lightGray.cgColor
        profileView.recentAchievementView.delegate = self
        profileView.recentAchievementView.dataSource = self
    }
    
    func setProfileTitle() {
        profileView.profileTitleView.layer.borderColor = UIColor.lightGray.cgColor
        profileView.profileTitleView.imageView.layer.borderColor = UIColor.lightGray.cgColor
        profileView.profileTitleView.imageView.layer.borderWidth = 1
        profileView.profileTitleView.imageView.layer.cornerRadius = 50
        profileView.profileTitleView.clipsToBounds = true
        profileView.profileTitleView.title.text = "Titulo"
    }
    
    func setProgressView() {
        profileView.profileProgressView.experienceProgressView.text = "25%"
        profileView.profileProgressView.experienceProgressView.textColor = Color.orange
        profileView.profileProgressView.experienceProgressView.lineWidth = CGFloat(7)
        profileView.profileProgressView.experienceProgressView.textSize = CGFloat(20)
        profileView.profileProgressView.experienceProgressView.backgroundBarColor = Color.lightOrange
        profileView.profileProgressView.experienceProgressView.foregroundBarColor = Color.orange
        profileView.profileProgressView.experienceProgressView.maximumBarColor = Color.orange
        profileView.profileProgressView.experienceProgressView.animationDuration = TimeInterval(1.0)
        profileView.profileProgressView.experienceProgressView.setProgress(to: 0.25, animated: true)
        profileView.profileProgressView.experienceProgressView.awakeFromNib()
   
        profileView.profileProgressView.placesProgressView.text = "50%"
        profileView.profileProgressView.placesProgressView.textColor = Color.orange
        profileView.profileProgressView.placesProgressView.lineWidth = CGFloat(7)
        profileView.profileProgressView.placesProgressView.textSize = CGFloat(20)
        profileView.profileProgressView.placesProgressView.backgroundBarColor = Color.lightOrange
        profileView.profileProgressView.placesProgressView.foregroundBarColor = Color.orange
        profileView.profileProgressView.placesProgressView.maximumBarColor = Color.orange
        profileView.profileProgressView.placesProgressView.animationDuration = TimeInterval(1.0)
        profileView.profileProgressView.placesProgressView.setProgress(to: 0.5, animated: true)
        profileView.profileProgressView.placesProgressView.awakeFromNib()
        
        profileView.profileProgressView.achievementProgressView.text = "60%"
        profileView.profileProgressView.achievementProgressView.textColor = Color.orange
        profileView.profileProgressView.achievementProgressView.lineWidth = CGFloat(7)
        profileView.profileProgressView.achievementProgressView.textSize = CGFloat(20)
        profileView.profileProgressView.achievementProgressView.backgroundBarColor = Color.lightOrange
        profileView.profileProgressView.achievementProgressView.foregroundBarColor = Color.orange
        profileView.profileProgressView.achievementProgressView.maximumBarColor = Color.orange
        profileView.profileProgressView.achievementProgressView.animationDuration = TimeInterval(1.0)
        profileView.profileProgressView.achievementProgressView.setProgress(to: 0.6, animated: true)
        profileView.profileProgressView.achievementProgressView.awakeFromNib()
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = profileView.recentAchievementView.dequeueReusableCell(withReuseIdentifier: "achievementCell", for: indexPath as IndexPath) as! AchievementCell
        cellView.titleLabel.text = "Lorem Ipsum"
        cellView.layer.borderColor = UIColor.systemGray.cgColor
        cellView.layer.borderWidth = 0.5
        cellView.achievementProgressView.awakeFromNib()
        return cellView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAchievement" {
            let destVC = segue.destination as! AchievementController
            destVC.loadViewIfNeeded()
            //destVC.achievementView.achievementLabel.text = "teste"
        }
    }
}
