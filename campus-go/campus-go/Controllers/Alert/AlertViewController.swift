//
//  AlertViewController.swift
//  campus-go
//
//  Created by Giordano Mattiello on 25/11/21.
//

import Foundation

import Foundation
import UIKit

protocol AlertViewDelegate: UIViewController{
    func goToDetails(place: Place)
}

class AlertViewController: UIViewController {
    weak var delegate: AlertViewDelegate?
    
    @IBOutlet weak var experienceProgressView: CircularProgressView!
    @IBOutlet weak var rigthProgressView: CircularProgressView!
    @IBOutlet weak var unlockLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var experienceLargeLabel: UILabel!
    @IBOutlet weak var experienceSmallLabel: UILabel!
    @IBOutlet weak var rigthLargeLabel: UILabel!
    @IBOutlet weak var rigthSmallLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var centralIcon: UIImageView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var parentView: UIView!
    
    var place:Place?
    var achievement:Achievement?
    
    @IBAction func closeAlert(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
        })
    }
    
    @IBAction func seeDetails(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: {
            if let place = self.place {
                self.delegate?.goToDetails(place: place)
            }
           
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let place = place{
            setPlaceInfo(place)
        } else if let achievement = achievement {
            setAchievementInfo(achievement)
        } else {
            print("Send a place or a achievement")
        }
    }

    
    func setParentViewLayout(){
        parentView.layer.borderColor = UIColor.lightGray.cgColor
        parentView.layer.borderWidth = 0.5
        parentView.layer.shadowColor = UIColor.black.cgColor
        parentView.layer.shadowOpacity = 0.25
        parentView.layer.shadowOffset = .zero
        parentView.layer.shadowRadius = 10
    }
    
    func setPlaceInfo(_ place: Place){
        centralIcon.image = UIImage(named: "alert-place-icon")
        unlockLabel.text = "Você desbloqueou o local"
        if let name = place.name{
            nameLabel.text = name.components(separatedBy: " - ")[1]
        }
        experienceLargeLabel.text = "+ 400"
        experienceSmallLabel.text = "XP conquistado"
        rigthLargeLabel.text = "+1"
        rigthSmallLabel.text = "Lugar visitado"
    }
    
    func setAchievementInfo(_ achievement: Achievement){
        centralIcon.image = UIImage(named: "A-\(achievement.achievementID)")
        unlockLabel.text = "Você desbloqueou a conquista"
        nameLabel.text = achievement.name
        experienceLargeLabel.text = String(achievement.xpPoints)
        experienceSmallLabel.text = "XP conquistado"
        rigthLargeLabel.text = "+1"
        rigthSmallLabel.text = "Conquista alcançada"
    }
    
    
    override func viewDidLayoutSubviews() {
        setProgress(progressView: experienceProgressView,progress: progressXp())
        if place != nil {
            setProgress(progressView: rigthProgressView,progress: progressPlaces() )
        } else {
            setProgress(progressView: rigthProgressView,progress: progressAchievement() )
        }
        
        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
        dismissButton.backgroundColor = UIColor(rgb: 0xE4E3E6)
        dismissButton.tintColor = UIColor(rgb: 0x7E7F83)
    }
    
    func setProgress(progressView: CircularProgressView,progress: Double){
        progressView.text = String(format: "%.0f",progress*100.0) + "%"
        progressView.textColor = Color.orange
        progressView.lineWidth = CGFloat(7)
        progressView.textSize = CGFloat(20)
        progressView.backgroundBarColor = Color.orangeTrans
        progressView.foregroundBarColor = Color.orange
        progressView.maximumBarColor = Color.orange
        progressView.animationDuration = TimeInterval(1.0)
        progressView.setProgress(to: progress, animated: true)
        progressView.awakeFromNib()
    }
    
    func progressPlaces() -> Double{
        var numberKnow:Int = 0
        let placeService = PlaceService()
        do{
            let places = try placeService.readAll()!
            numberKnow = places.reduce(0) {
                if( Int(PlaceState.known.rawValue) == Int($1.state) ){
                    return $0 + 1
                }
                return $0
            }
            return (Double(numberKnow) / Double(places.count) )
        }catch{
            print(error)
        }
        return 0.0
    }
    
    func progressXp() -> Double{
        let defautXp = 5
        
        var totalXp:Int = 0
        var currentXp:Int = 0
        
        let placeService = PlaceService()
        let achievementService = AchievementService()
        
        do {
            let achievements = try achievementService.retrieve()!
            for achievement in achievements{
                totalXp += Int(achievement.xpPoints)
                if(achievement.progress == 1.0 ){
                    currentXp += Int(achievement.xpPoints)
                }
            }
            
            let places = try placeService.readAll()!
            for place in places{
                totalXp += defautXp
                if( Int(PlaceState.known.rawValue) == Int(place.state) ){
                    currentXp += defautXp
                }
            }
        } catch {
            print(error)
            totalXp = 1
        }
        return Double(currentXp)/Double(totalXp)
    }
    func progressAchievement() -> Double{
        var numberAchievement:Int = 0
        let achievementService = AchievementService()
        do{
            let achievements = try achievementService.retrieve()!
            for achievement in achievements{
                if(achievement.progress == 1.0 ){
                    numberAchievement += 1
                }
            }
            return (Double(numberAchievement) / Double(achievements.count) )
        }catch{
            print(error)
        }
        return 0.0
    }
    func fakeAchievement() -> Achievement? {
        let achievementService = AchievementService()
        do{
            let achievements = try achievementService.retrieve()!
            return achievements[0]
        }catch{
            print(error)
        }
        return nil
    }
    
}
