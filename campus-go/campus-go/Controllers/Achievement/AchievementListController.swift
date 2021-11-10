//
//  AchievementListController.swift
//  campus-go
//
//  Created by Vitor Jundi Moriya on 04/10/21.
//

import Foundation
import UIKit

class AchievementListController: UIViewController {
    
    @IBOutlet var achievementListView: AchievementListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        achievementListView.achievementCollection.delegate = self
        achievementListView.achievementCollection.dataSource = self
        
    }
}

extension AchievementListController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = achievementListView.achievementCollection.dequeueReusableCell(withReuseIdentifier: "achievementCell", for: indexPath)
        
        
        //cellView.titleLabel.text = "Lorem Ipsum"
        //cellView.image.image = UIImage(named: "books")
        cellView.layer.borderColor = UIColor(rgb: 0xC7C7CC).cgColor
        cellView.layer.borderWidth = 0.5
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
