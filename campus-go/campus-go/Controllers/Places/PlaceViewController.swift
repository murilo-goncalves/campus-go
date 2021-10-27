//
//  PlaceViewController.swift
//  campus-go
//
//  Created by Vinícius Flores Ribeiro on 27/10/21.
//

import Foundation
import UIKit

class PlaceViewController: UIViewController, UIScrollViewDelegate{
    
    //adicionar componentes aqui

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var images: [String] = ["RS-1", "RS-2", "RS-3"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        pageControl.numberOfPages = images.count
        
        for index in 0..<images.count{
            frame.origin.x = scrollView.frame.size.width*CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: images[index])
            self.scrollView.addSubview(imgView)
        }
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width*CGFloat(images.count)), height: 0)
        scrollView.delegate = self
    }
    
    //mudar a imagem e atualizar o pageControl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var pageNumber = scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
}
