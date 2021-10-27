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
        
        profileView.profileProgressView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        profileView.recentAchievementView.layer.borderColor = UIColor.lightGray.cgColor
        profileView.recentAchievementView.delegate = self
        profileView.recentAchievementView.dataSource = self
    }
    
    func setProfileTitle() {
        profileView.profileTitleView.layer.borderColor = UIColor.lightGray.cgColor
//        profileView.profileTitleView.imageView.image = UIImage(named: "books")
        profileView.profileTitleView.imageView.layer.borderColor = UIColor.lightGray.cgColor
        profileView.profileTitleView.imageView.layer.borderWidth = 1
        profileView.profileTitleView.imageView.layer.cornerRadius = 50
        profileView.profileTitleView.clipsToBounds = true
        profileView.profileTitleView.title.text = "Titulo"
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = profileView.recentAchievementView.dequeueReusableCell(withReuseIdentifier: "achievementCell", for: indexPath as IndexPath) as! AchievementCell
        cellView.titleLabel.text = "Lorem Ipsum"
        cellView.image.image = UIImage(named: "books")
        cellView.layer.borderColor = UIColor(rgb: 0xC7C7CC).cgColor
        cellView.layer.borderWidth = 0.5
        return cellView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAchievement" {
            let destVC = segue.destination as! AchievementController
            destVC.loadViewIfNeeded()
            destVC.achievementView.achievementLabel.text = "teste"
        }
    }
}
