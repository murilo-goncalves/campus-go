//
//  PlaceViewController.swift
//  campus-go
//
//  Created by Vinícius Flores Ribeiro on 27/10/21.
//

import Foundation
import UIKit

class PlaceViewController: UIViewController, UIScrollViewDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nomeLugar: UILabel!
    @IBOutlet weak var distanciaLugar: UILabel!
    
    var images: [String] = ["RS-1", "RS-2", "RS-3"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        nomeLugar.text = "Lugar desconhecido"
        distanciaLugar.text = "2.2 Km"
        
        
        
        var currentImageView: UIImageView! = nil
        for index in 0..<images.count{

            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            imgView.translatesAutoresizingMaskIntoConstraints = false
            self.scrollView.addSubview(imgView)

            imgView.image = UIImage(named: images[index])
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
            
            //precisa setar manualmente as constraints na scrollView
            //primeira imagem, intermediárias, última imagem
            if index == 0 {
                let constraints = [imgView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                                   imgView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                                   imgView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                                   imgView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)]
                NSLayoutConstraint.activate(constraints)
                currentImageView = imgView
            }
            if index > 0 && index < (images.count - 1){
                let constraints = [imgView.leadingAnchor.constraint(equalTo: currentImageView.trailingAnchor),
                                   imgView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                                   imgView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                                   imgView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)]
                NSLayoutConstraint.activate(constraints)
                currentImageView = imgView
            }
            
            if index == (images.count - 1){
                let constraints = [imgView.leadingAnchor.constraint(equalTo: currentImageView.trailingAnchor),
                                   imgView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                                   imgView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                                   imgView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                                   imgView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)]
                NSLayoutConstraint.activate(constraints)
            }
            
        }
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
    }
    
    //Depois de aparecer na tela
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(scrollView.frame)
    }
    
    //Antes de aparecer na tela
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(scrollView.frame)
    }
    
    //atualizar o pageControl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x/scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
}
