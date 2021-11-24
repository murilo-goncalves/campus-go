//
//  AchievementProgressView.swift
//  campus-go
//
//  Created by Vitor Jundi Moriya on 03/11/21.
//

import Foundation
import UIKit

class AchievementProgressView: UIView {
    @IBOutlet weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("AchievementProgressView", owner: self, options: nil)
        let path = UIBezierPath(ovalIn: CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y, width: contentView.frame.width, height: contentView.frame.height))
        let progressLayer = CAShapeLayer()
        progressLayer.path = path.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = Color.orangeTrans.cgColor
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 1
        progressLayer.lineWidth = 2
        progressLayer.lineCap = .round
        contentView.layer.addSublayer(progressLayer)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = Color.orange.cgColor
        layer.strokeStart = 0.8
        layer.strokeEnd = 1
        layer.lineWidth = 2
        layer.lineCap = .round
        contentView.layer.addSublayer(layer)
        addSubview(contentView)
    }
}
