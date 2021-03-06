//
//  ProfileViewController.swift
//  campus-go
//
//  Created by Murilo Gonçalves on 29/09/21.
//

import Foundation
import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var bottomCollectionConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblXP: UILabel!
    @IBOutlet weak var lblPlaces: UILabel!
    @IBOutlet weak var lblAchievement: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var profileView: ProfileView!
    let achievementService = AchievementService()
    var listAchievements: [Achievement] = []
    let userAttributes = UserAttributes()
    @IBOutlet weak var experienceProgressViewView: UIView!
    @IBOutlet weak var placesProgressViewView: UIView!
    @IBOutlet weak var achievementsProgressViewView: UIView!
    
//    @objc func alertTest(){
//        let alert = AlertUtil()
//        alert.showAlert(viewController: self, place: nil, achievement: nil)
//    }
//    profileView.profileTitleView.imageView.isUserInteractionEnabled = true
//    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(alertTest))
//    profileView.profileTitleView.imageView.addGestureRecognizer(tapGestureRecognizer)
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = Color.background
        setProfileTitle()
        profileView.profileProgressView.layer.borderColor = UIColor.lightGray.cgColor
        profileView.recentAchievementView.register(AchievementCollectionViewCell.nib(), forCellWithReuseIdentifier: AchievementCollectionViewCell.identifier)
        profileView.recentAchievementView.layer.borderColor = UIColor.lightGray.cgColor
        profileView.recentAchievementView.delegate = self
        profileView.recentAchievementView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        profileView.recentAchievementView.collectionViewLayout = layout
        
        
        let experienceGR = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        let placesGR = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        let achievementsGR = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        experienceGR.numberOfTapsRequired = 1
        experienceGR.numberOfTouchesRequired = 1
        placesGR.numberOfTapsRequired = 1
        placesGR.numberOfTouchesRequired = 1
        achievementsGR.numberOfTapsRequired = 1
        achievementsGR.numberOfTouchesRequired = 1
        experienceProgressViewView.addGestureRecognizer(experienceGR)
        placesProgressViewView.addGestureRecognizer(placesGR)
        achievementsProgressViewView.addGestureRecognizer(achievementsGR)
        experienceProgressViewView.isUserInteractionEnabled = true
        placesProgressViewView.isUserInteractionEnabled = true
        achievementsProgressViewView.isUserInteractionEnabled = true
    }
    override func viewDidLayoutSubviews() {
        bottomCollectionConstraint.constant = bottomCollectionConstraint.constant + CGFloat(Int(profileView.recentAchievementView.frame.height) % 76)
        updateProgressView()
        profileView.profileTitleView.clipsToBounds = true
        profileView.profileTitleView.imageView.layer.cornerRadius = profileView.profileTitleView.imageView.layer.frame.width/2        
    }
    override func viewWillAppear(_ animated: Bool) {
        updateProgressView()
    }
    
    @objc func didTapView(_ gesture: UITapGestureRecognizer){
        if gesture.view == experienceProgressViewView {
            performSegue(withIdentifier: "goToRanks", sender: self)
        }
        if gesture.view == placesProgressViewView {
            performSegue(withIdentifier: "goToPlaces", sender: self)
        }
        if gesture.view == achievementsProgressViewView {
            performSegue(withIdentifier: "goToAchievementsList", sender: self)
        }
    }
    private func updateProgressView() {
        do {
            guard let list = try achievementService.retrieve() else { return }
            listAchievements = list
            listAchievements.sort(by: {
                if $0.progress == $1.progress {
                    return $0.name! < $1.name!
                }
                return $0.progress > $1.progress
            })
        } catch {
            print(error)
        }
        setProgressView()
        self.lblPlaces.text = "\(userAttributes.getUserPlaces())"
        self.lblXP.text = "\(userAttributes.getUserXP())"
        self.lblAchievement.text = "\(userAttributes.getUserAchievements())"
    }
    private func setProgressView() {
        setXPProgress()
        setPlaceProgress()
        setAchievementProgress()
    }
    private func setProfileTitle() {
        
        profileView.profileTitleView.layer.borderColor = UIColor.lightGray.cgColor
        profileView.profileTitleView.imageView.layer.borderColor = UIColor.lightGray.cgColor
        profileView.profileTitleView.imageView.layer.borderWidth = 1
        
        profileView.profileTitleView.title.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTitle)))
        
        let user = try! UserService().read()
        profileView.profileTitleView.title.text = user?.name
        if user?.image == nil {
            profileView.profileTitleView.imageView.image = UIImage(systemName: "person.fill")
        } else {
            profileView.profileTitleView.imageView.image = UIImage(data: user!.image!)
        }
    }
    
    private func setXPProgress() {
        profileView.profileProgressView.experienceProgressView.lineWidth = CGFloat(7)
        profileView.profileProgressView.experienceProgressView.textSize = CGFloat(20)
        profileView.profileProgressView.experienceProgressView.awakeFromNib()
        let percentualXP = PercentValues.getPercentualXP()
        //Aqui eu vou setar as cores de acordo com o progresso
        if(percentualXP == 0.0) {
            profileView.profileProgressView.experienceProgressView.text = "0%"
            profileView.profileProgressView.experienceProgressView.textColor = Color.purple
            profileView.profileProgressView.experienceProgressView.backgroundBarColor = Color.purpleTrans
            profileView.profileProgressView.experienceProgressView.foregroundBarColor = Color.purple
            profileView.profileProgressView.experienceProgressView.maximumBarColor = Color.purple
            
        } else if(percentualXP == 1.0) {
            profileView.profileProgressView.experienceProgressView.text = "100%"
            profileView.profileProgressView.experienceProgressView.textColor = Color.green
            profileView.profileProgressView.experienceProgressView.backgroundBarColor = Color.green
            profileView.profileProgressView.experienceProgressView.foregroundBarColor = Color.green
            profileView.profileProgressView.experienceProgressView.maximumBarColor = Color.green
        }
        else {
            profileView.profileProgressView.experienceProgressView.setProgress(to: percentualXP, animated: true)
            profileView.profileProgressView.experienceProgressView.animationDuration = TimeInterval(1.0)
            profileView.profileProgressView.experienceProgressView.textColor = Color.orange
            profileView.profileProgressView.experienceProgressView.backgroundBarColor = Color.orangeTrans
            profileView.profileProgressView.experienceProgressView.foregroundBarColor = Color.orange
            profileView.profileProgressView.experienceProgressView.maximumBarColor = Color.orange
            profileView.profileProgressView.experienceProgressView.text = "\(Int(percentualXP * 100))%"
        }
    }
    
    private func setPlaceProgress() {
        profileView.profileProgressView.placesProgressView.lineWidth = CGFloat(7)
        profileView.profileProgressView.placesProgressView.textSize = CGFloat(20)
        profileView.profileProgressView.placesProgressView.awakeFromNib()
        let percentualPlaces = PercentValues.getPercentualPlaces()
        //Aqui eu vou setar as cores de acordo com o progresso
        if(percentualPlaces == 0.0) {
            profileView.profileProgressView.placesProgressView.text = "0%"
            profileView.profileProgressView.placesProgressView.textColor = Color.purple
            profileView.profileProgressView.placesProgressView.backgroundBarColor = Color.purpleTrans
            profileView.profileProgressView.placesProgressView.foregroundBarColor = Color.purple
            profileView.profileProgressView.placesProgressView.maximumBarColor = Color.purple
            
        } else if(percentualPlaces == 1.0) {
            profileView.profileProgressView.placesProgressView.text = "100%"
            profileView.profileProgressView.placesProgressView.textColor = Color.green
            profileView.profileProgressView.placesProgressView.backgroundBarColor = Color.green
            profileView.profileProgressView.placesProgressView.foregroundBarColor = Color.green
            profileView.profileProgressView.placesProgressView.maximumBarColor = Color.green
        }
        else {
            profileView.profileProgressView.placesProgressView.setProgress(to: percentualPlaces, animated: true)
            profileView.profileProgressView.placesProgressView.animationDuration = TimeInterval(1.0)
            profileView.profileProgressView.placesProgressView.textColor = Color.orange
            profileView.profileProgressView.placesProgressView.backgroundBarColor = Color.orangeTrans
            profileView.profileProgressView.placesProgressView.foregroundBarColor = Color.orange
            profileView.profileProgressView.placesProgressView.maximumBarColor = Color.orange
            profileView.profileProgressView.placesProgressView.text = "\(Int(percentualPlaces * 100))%"
        }
    }
    
    private func setAchievementProgress() {
        profileView.profileProgressView.achievementProgressView.lineWidth = CGFloat(7)
        profileView.profileProgressView.achievementProgressView.textSize = CGFloat(20)
        profileView.profileProgressView.achievementProgressView.awakeFromNib()
        let percentualAchievements = PercentValues.getPercentualAchievements()
        //Aqui eu vou setar as cores de acordo com o progresso
        if(percentualAchievements == 0.0) {
            profileView.profileProgressView.achievementProgressView.text = "0%"
            profileView.profileProgressView.achievementProgressView.textColor = Color.purple
            profileView.profileProgressView.achievementProgressView.backgroundBarColor = Color.purpleTrans
            profileView.profileProgressView.achievementProgressView.foregroundBarColor = Color.purple
            profileView.profileProgressView.achievementProgressView.maximumBarColor = Color.purple
            
        } else if(percentualAchievements == 1.0) {
            profileView.profileProgressView.achievementProgressView.text = "100%"
            profileView.profileProgressView.achievementProgressView.textColor = Color.green
            profileView.profileProgressView.achievementProgressView.backgroundBarColor = Color.green
            profileView.profileProgressView.achievementProgressView.foregroundBarColor = Color.green
            profileView.profileProgressView.achievementProgressView.maximumBarColor = Color.green
        }
        else {
            profileView.profileProgressView.achievementProgressView.setProgress(to: percentualAchievements, animated: true)
            profileView.profileProgressView.achievementProgressView.animationDuration = TimeInterval(1.0)
            profileView.profileProgressView.achievementProgressView.textColor = Color.orange
            profileView.profileProgressView.achievementProgressView.backgroundBarColor = Color.orangeTrans
            profileView.profileProgressView.achievementProgressView.foregroundBarColor = Color.orange
            profileView.profileProgressView.achievementProgressView.maximumBarColor = Color.orange
            profileView.profileProgressView.achievementProgressView.text = "\(Int(percentualAchievements * 100))%"
        }
    }
    
    @objc func tapTitle(sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Nome", message: "Insira um nome", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Nome"
        }


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Salvar", style: .default) { _ in
            
            self.profileView.profileTitleView.title.text = alertController.textFields![0].text

            try! UserService().update(name: alertController.textFields![0].text!)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
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
extension ProfileViewController: AlertViewDelegate{
    func goToDetails(place: Place) {
        let storyboard = UIStoryboard(name: "Place", bundle: nil)
        if let placeViewController = storyboard.instantiateViewController(withIdentifier: "PlaceDetails") as? PlaceViewController{
            placeViewController.place = place
            self.navigationController?.pushViewController(placeViewController, animated: true)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate,          UINavigationControllerDelegate {
    
    @IBAction func imageTap(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        profileView.profileTitleView.imageView.image = image
        let userService = UserService()
        try! userService.update(image: (image?.pngData())!)
        self.dismiss(animated: true)
    }
}
