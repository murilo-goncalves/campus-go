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
    
    @IBOutlet weak var bottomCollectionConstraints: NSLayoutConstraint!
    @IBOutlet var placeView: PlaceView!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var placeButton: UIButton!
    
    var place = Place()
    var listAchievements: [Achievement] = []
    var pictureService = Pictures()
    var images: [String] = []
    let placeService = PlaceService()
    let achievementService = AchievementService()
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    //apenas recebendo infomração do PlacesViewController
    var indexPath: IndexPath!
    
    var annotation: CustomAnnotation?
    var userCoordinate: CLLocationCoordinate2D?
    var placeCoordinate: CLLocationCoordinate2D?
    weak var routeDelegate: RouteDelegate?
    weak var annotationDelegate: AnnotationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let relatedAchievements = RelatedAchievements(place: self.place)
            for uid in relatedAchievements.placeAchievements {
                guard let conquista = try achievementService.retrieve(uid: uid) else { continue }
                listAchievements.append(conquista)
            }
        } catch {
            print(error)
        }
        
        self.view.backgroundColor = Color.background

        placeCoordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        
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
               
        var currentImageView: UIImageView! = nil
        for index in 0..<images.count{

            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            imgView.translatesAutoresizingMaskIntoConstraints = false
            self.placeView.scrollView.addSubview(imgView)

            imgView.image = UIImage(named: images[index])
            imgView.contentMode = .scaleAspectFill
            imgView.layer.borderWidth = 0.5
            imgView.layer.borderColor = UIColor.lightGray.cgColor
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
        roundButtonsCorners()
        
    }
    private func roundButtonsCorners(){
        goButton.layer.cornerRadius = 5
        placeButton.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        placeView.recentAchievement.layer.borderWidth = 1
        placeView.recentAchievement.layer.borderColor = UIColor.lightGray.cgColor
        placeView.recentAchievement.layer.cornerRadius = 5
        bottomCollectionConstraints.constant = bottomCollectionConstraints.constant + CGFloat(Int(placeView.recentAchievement.frame.height) % 76)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Calcula a distância entre o usuário e o lugar
    func calculaDistancia(_ userLocation: CLLocationCoordinate2D?, _ placeLocation: CLLocationCoordinate2D?) -> Double {
        
        guard let userLocation = userLocation else { return -1.0 }
        guard let placeLocation = placeLocation else { return -1.0 }
        let uLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let pLocation = CLLocation(latitude: placeLocation.latitude, longitude: placeLocation.longitude)
        var distance  = uLocation.distance(from: pLocation) as Double
        formataDistancia(&distance)
        return distance
        
    }
    //formata a distancia para quilômetros com duas casas decimais
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
        _ = navigationController?.popViewController(animated: true)
        self.navigationController?.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func mapButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 1
        (UIApplication.shared.delegate as! AppDelegate).clickedLocation = placeCoordinate!
        routeDelegate?.didTapLocation(locationCoordinate: placeCoordinate!)
    }
}


extension PlaceViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(Int(collectionView.frame.height / 76), listAchievements.count)
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
extension PlaceViewController: UICollectionViewDelegateFlowLayout{
    // MARK: UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: placeView.recentAchievement.frame.width ,height: 76)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


