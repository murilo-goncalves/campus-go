//
//  PlaceViewController.swift
//  campus-go
//
//  Created by Vinícius Flores Ribeiro on 27/10/21.
//

import UIKit
import CoreLocation
import Foundation
class PlaceViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate {
    
    @IBOutlet var placeView: PlaceView!
    
    var place = Place()
    var pictureService = Pictures()
    var images: [String] = []
    let placeService = PlaceService()
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    //apenas recebendo infomração do PlacesViewController
    var indexPath: IndexPath!
    
    var placeCoordinate: CLLocationCoordinate2D?
    var userCoordinate: CLLocationCoordinate2D?
    weak var routeDelegate: RouteDelegate?
    weak var annotationDelegate: AnnotationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = place.name {
            if(place.state == PlaceState.known.rawValue) {
                title = name.components(separatedBy: " - ")[0]
                placeView.nomeLugar.text = name
            } else {
                title = "Desconhecido"
                placeView.nomeLugar.text = "Lugar desconhecido"
            }
            
        } else {
            title = ""
            placeView.nomeLugar.text = ""
        }
       
        
        pictureService = Pictures(placeID: Int(place.placeID), numberOfPictures: Int(place.nImages))
        images = pictureService.listPictures
        placeView.pageControl.numberOfPages = images.count
        placeView.pageControl.currentPage = 0

        
        if let userCoord = userCoordinate{
            let dist = calculaDistancia(userCoord, placeCoordinate)
            placeView.distanciaLugar.text = dist < 1.0 ? "\(dist*1000) m" : "\((dist*10).rounded()/10) km"
            
           
        } else {
            placeView.distanciaLugar.text = ""
        }

        
        
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
            
            // precisa setar manualmente as constraints na scrollView
            // primeira imagem, intermediárias, última imagem
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
        
        placeView.recentAchievement.register(AchievementCollectionViewCell.nib(), forCellWithReuseIdentifier: AchievementCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        placeView.recentAchievement.collectionViewLayout = layout
        
    }
    
    //Depois de aparecer na tela
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        placeView.recentAchievement.layer.borderWidth = 1
        placeView.recentAchievement.layer.borderColor = UIColor.lightGray.cgColor
        placeView.recentAchievement.layer.cornerRadius = 5
        //print(placeView.scrollView.frame)
    }
    
    //Antes de aparecer na tela
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print(placeView.scrollView.frame)
    }
    
    //Calcula a distância entre o usuário e o lugar
    
    func calculaDistancia(_ userLocation: CLLocationCoordinate2D?, _ placeLocation: CLLocationCoordinate2D?) -> Double {
        
        guard let userLocation = userLocation else {
            return -1.0
        }
        guard let placeLocation = placeLocation else {
            return -1.0
        }
        
        let uLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let pLocation = CLLocation(latitude: placeLocation.latitude, longitude: placeLocation.longitude)
        var distance  = uLocation.distance(from: pLocation) as Double
        formataDistancia(&distance)
        return distance
    }
    
    func formataDistancia(_ distance: inout Double) {
        distance = distance/1000.0
        distance = (distance*100).rounded()/100
    }
    
    //atualizar o pageControl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x/scrollView.frame.size.width)
        placeView.pageControl.currentPage = Int(pageNumber)
    }
    
    @IBAction func goBtnAction(_ sender: UIButton) {
        try! placeService.updateState(uid: place.uid!, newState: PlaceState.onRoute)
        routeDelegate?.didTapGo(destinationCoordinate: placeCoordinate!)
        annotationDelegate?.updateAnnotations()
        _ = navigationController?.popViewController(animated: true)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchievementCollectionViewCell.identifier, for: indexPath) as! AchievementCollectionViewCell
        cell.configure(hasProgress: false)
        return cell
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAchievement" {
            let destVC = segue.destination as! AchievementController
            destVC.loadViewIfNeeded()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showAchievement", sender: collectionView.cellForItem(at: indexPath))
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }

}
extension PlaceViewController: UICollectionViewDelegateFlowLayout{
    // MARK: UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: placeView.recentAchievement.frame.width ,height: 76)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

