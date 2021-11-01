//
//  PlaceViewController.swift
//  campus-go
//
//  Created by Vinícius Flores Ribeiro on 27/10/21.
//

import Foundation
import UIKit

class PlaceViewController: UIViewController, UIScrollViewDelegate{


    @IBOutlet var placeView: PlaceView!
    
    var images: [String] = ["RS-1", "RS-2", "RS-3"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        placeView.pageControl.numberOfPages = images.count
        placeView.pageControl.currentPage = 0
        placeView.nomeLugar.text = "Lugar desconhecido"
        placeView.distanciaLugar.text = "2.2 Km"
        
        var currentImageView: UIImageView! = nil
        for index in 0..<images.count{

            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            imgView.translatesAutoresizingMaskIntoConstraints = false
            self.placeView.scrollView.addSubview(imgView)

            imgView.image = UIImage(named: images[index])
            imgView.contentMode = .scaleAspectFit
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
    }
    
    //Depois de aparecer na tela
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(placeView.scrollView.frame)
    }
    
    //Antes de aparecer na tela
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(placeView.scrollView.frame)
    }
    
    //atualizar o pageControl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x/scrollView.frame.size.width)
        placeView.pageControl.currentPage = Int(pageNumber)
    }
    
}
