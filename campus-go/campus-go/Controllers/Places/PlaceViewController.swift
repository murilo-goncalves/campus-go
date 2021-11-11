//
//  PlaceViewController.swift
//  campus-go
//
//  Created by Vinícius Flores Ribeiro on 27/10/21.
//

import Foundation
import UIKit

class PlaceViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate{


    @IBOutlet var placeView: PlaceView!
    
    var images: [String] = ["unicamp-pb", "unicamp-pb", "unicamp-pb"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    //apenas recebendo infomração do PlacesViewController
    var indexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        placeView.pageControl.numberOfPages = images.count
        placeView.pageControl.currentPage = 0
        placeView.nomeLugar.text = "Lugar desconhecido"
        placeView.distanciaLugar.text = "2.2 Km"
        placeView.recentAchievement.layer.cornerRadius = 15.0
        placeView.recentAchievement.layer.borderWidth = 5.0
        placeView.recentAchievement.layer.borderColor = UIColor.clear.cgColor
        placeView.recentAchievement.layer.masksToBounds = true
       
        //apenas usando a informação do PlacesViewController
        //print("You tapped me", indexPath! )
        
        var currentImageView: UIImageView! = nil
        for index in 0..<images.count{

            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            imgView.translatesAutoresizingMaskIntoConstraints = false
            self.placeView.scrollView.addSubview(imgView)

            imgView.image = UIImage(named: images[index])
            imgView.contentMode = .scaleAspectFill
            imgView.layer.cornerRadius = 10
            imgView.clipsToBounds = true
            
            //precisa setar manualmente as constraints na scrollView
            //primeira imagem, intermediárias, última imagem
            if index == 0 {
                let constraints = [imgView.leadingAnchor.constraint(equalTo: placeView.scrollView.leadingAnchor),
                                   imgView.topAnchor.constraint(equalTo: placeView.scrollView.topAnchor),
                                   imgView.heightAnchor.constraint(equalTo: placeView.scrollView.heightAnchor),
                                   imgView.widthAnchor.constraint(equalTo: placeView.scrollView.widthAnchor)]
                NSLayoutConstraint.activate(constraints)
                currentImageView = imgView
            }
            if index > 0 && index < (images.count - 1){
                let constraints = [imgView.leadingAnchor.constraint(equalTo: currentImageView.trailingAnchor),
                                   imgView.topAnchor.constraint(equalTo: placeView.scrollView.topAnchor),
                                   imgView.heightAnchor.constraint(equalTo: placeView.scrollView.heightAnchor),
                                   imgView.widthAnchor.constraint(equalTo: placeView.scrollView.widthAnchor)]
                NSLayoutConstraint.activate(constraints)
                currentImageView = imgView
            }
            
            if index == (images.count - 1){
                let constraints = [imgView.leadingAnchor.constraint(equalTo: currentImageView.trailingAnchor),
                                   imgView.topAnchor.constraint(equalTo: placeView.scrollView.topAnchor),
                                   imgView.heightAnchor.constraint(equalTo: placeView.scrollView.heightAnchor),
                                   imgView.widthAnchor.constraint(equalTo: placeView.scrollView.widthAnchor),
                                   imgView.trailingAnchor.constraint(equalTo: placeView.scrollView.trailingAnchor)]
                NSLayoutConstraint.activate(constraints)
            }
            
        }
        placeView.scrollView.delegate = self
        placeView.scrollView.isPagingEnabled = true
        placeView.recentAchievement.dataSource = self
        placeView.recentAchievement.delegate = self
    }
    
    //Depois de aparecer na tela
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print(placeView.scrollView.frame)
    }
    
    //Antes de aparecer na tela
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print(placeView.scrollView.frame)
    }
    
    //atualizar o pageControl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x/scrollView.frame.size.width)
        placeView.pageControl.currentPage = Int(pageNumber)
    }
    
}

extension PlaceViewController: UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = placeView.recentAchievement.dequeueReusableCell(withReuseIdentifier: "recentAchievementCell", for: indexPath as IndexPath) as! RecentAchievementCell
        cellView.achievementName.text = "Name"
        cellView.achievementDescription.text = "Description"
        cellView.achievementImage.image = UIImage(named: "books")
        cellView.layer.borderColor = UIColor.systemGray.cgColor
        cellView.layer.borderWidth = 0.5
        
        return cellView
    }

}
extension UICollectionView {
}


