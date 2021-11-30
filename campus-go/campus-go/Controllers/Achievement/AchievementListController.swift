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
        achievementListView.achievementCollection.delegate = self
        achievementListView.achievementCollection.dataSource = self
        achievementListView.achievementCollection.register(AchievementCollectionViewCell.nib(), forCellWithReuseIdentifier: AchievementCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        achievementListView.achievementCollection.collectionViewLayout = layout
    }
}

extension AchievementListController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listAchievements.count
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
extension AchievementListController: UICollectionViewDelegateFlowLayout{
    // MARK: UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: achievementListView.achievementCollection.frame.width ,height: 76)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
