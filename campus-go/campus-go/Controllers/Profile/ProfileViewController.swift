//
//  ProfileViewController.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 29/09/21.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var bottomCollectionConstraint: NSLayoutConstraint!
    @IBOutlet var profileView: ProfileView!
    let achievementService = AchievementService()
    var listAchievements: [Achievement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            guard let list = try achievementService.retrieve() else { return }
            listAchievements = list
        } catch {
            print(error)
        }
        self.view.backgroundColor = Color.background
        setProfileTitle()
        profileView.profileProgressView.layer.borderColor = UIColor.lightGray.cgColor
        profileView.recentAchievementView.register(AchievementCollectionViewCell.nib(), forCellWithReuseIdentifier: AchievementCollectionViewCell.identifier)
        profileView.recentAchievementView.layer.borderColor = UIColor.lightGray.cgColor
        profileView.recentAchievementView.delegate = self
        profileView.recentAchievementView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        profileView.recentAchievementView.collectionViewLayout = layout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        profileView.profileTitleView.clipsToBounds = true
        profileView.profileTitleView.imageView.layer.cornerRadius = profileView.profileTitleView.imageView.layer.frame.width/2
        setProgressView()
        bottomCollectionConstraint.constant = bottomCollectionConstraint.constant + CGFloat(Int(profileView.recentAchievementView.frame.height) % 76)
    }
    
    func setProfileTitle() {
        profileView.profileTitleView.layer.borderColor = UIColor.lightGray.cgColor
        profileView.profileTitleView.imageView.layer.borderColor = UIColor.lightGray.cgColor
        profileView.profileTitleView.imageView.layer.borderWidth = 1
        profileView.profileTitleView.title.text = "Titulo"
    }
    
    func setProgressView() {
        profileView.profileProgressView.experienceProgressView.text = "25%"
        profileView.profileProgressView.experienceProgressView.textColor = Color.orange
        profileView.profileProgressView.experienceProgressView.lineWidth = CGFloat(7)
        profileView.profileProgressView.experienceProgressView.textSize = CGFloat(20)
        profileView.profileProgressView.experienceProgressView.backgroundBarColor = Color.orangeTrans
        profileView.profileProgressView.experienceProgressView.foregroundBarColor = Color.orange
        profileView.profileProgressView.experienceProgressView.maximumBarColor = Color.orange
        profileView.profileProgressView.experienceProgressView.animationDuration = TimeInterval(1.0)
        profileView.profileProgressView.experienceProgressView.setProgress(to: 0.25, animated: true)
        profileView.profileProgressView.experienceProgressView.awakeFromNib()
   
        profileView.profileProgressView.placesProgressView.text = "50%"
        profileView.profileProgressView.placesProgressView.textColor = Color.orange
        profileView.profileProgressView.placesProgressView.lineWidth = CGFloat(7)
        profileView.profileProgressView.placesProgressView.textSize = CGFloat(20)
        profileView.profileProgressView.placesProgressView.backgroundBarColor = Color.orangeTrans
        profileView.profileProgressView.placesProgressView.foregroundBarColor = Color.orange
        profileView.profileProgressView.placesProgressView.maximumBarColor = Color.orange
        profileView.profileProgressView.placesProgressView.animationDuration = TimeInterval(1.0)
        profileView.profileProgressView.placesProgressView.setProgress(to: 0.5, animated: true)
        profileView.profileProgressView.placesProgressView.awakeFromNib()
        
        profileView.profileProgressView.achievementProgressView.text = "60%"
        profileView.profileProgressView.achievementProgressView.textColor = Color.orange
        profileView.profileProgressView.achievementProgressView.lineWidth = CGFloat(7)
        profileView.profileProgressView.achievementProgressView.textSize = CGFloat(20)
        profileView.profileProgressView.achievementProgressView.backgroundBarColor = Color.orangeTrans
        profileView.profileProgressView.achievementProgressView.foregroundBarColor = Color.orange
        profileView.profileProgressView.achievementProgressView.maximumBarColor = Color.orange
        profileView.profileProgressView.achievementProgressView.animationDuration = TimeInterval(1.0)
        profileView.profileProgressView.achievementProgressView.setProgress(to: 0.6, animated: true)
        profileView.profileProgressView.achievementProgressView.awakeFromNib()
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  min(Int(collectionView.frame.height / 76), listAchievements.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchievementCollectionViewCell.identifier, for: indexPath) as! AchievementCollectionViewCell
        cell.configure(achievement: listAchievements[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAchievement" {
            let destVC = segue.destination as! AchievementController
            let cell = sender as! AchievementCollectionViewCell
            do {
                destVC.conquista_ = try achievementService.retrieve(uid: cell.uid!)
            } catch {
                print(error)
            }
            destVC.loadViewIfNeeded()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showAchievement", sender: collectionView.cellForItem(at: indexPath))
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout{
    
    // MARK: UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: profileView.recentAchievementView.frame.width ,height: 76)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
