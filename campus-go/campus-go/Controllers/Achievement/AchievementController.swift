//
//  AchievementController.swift
//  campus-go
//
//  Created by Vitor Jundi Moriya on 04/10/21.
//

import Foundation
import UIKit

class AchievementController: UIViewController {
    
    @IBOutlet var achievementView: AchievementView!
    var conquista_: Achievement?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let conquista = conquista_ else { return }
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        //Aqui está como books pq a tabela de achievements ainda não tem o campo da imagem
        imgView.image = UIImage(named: "books")
        imgView.contentMode = .scaleAspectFill
        imgView.layer.borderWidth = 0.5
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        imgView.layer.cornerRadius = 10
        imgView.clipsToBounds = true
        achievementView.image = imgView
        achievementView.title.text = conquista.name
        achievementView.xp.text = "\(conquista.xpPoints) XP"
        //sugiro trocar a condition pra um número entre 0 e 1
        if(conquista.progress == 0.0) {
            achievementView.secondLabel.text = "Você ainda não tem progresso nesta conquista"
        }
        else if (conquista.progress == 1.0) {
            achievementView.secondLabel.text = "Conquista completa"
        }
        else {
            achievementView.secondLabel.text = "Você completou \(conquista.progress) da conquista"
        }
        
        
    }
}
