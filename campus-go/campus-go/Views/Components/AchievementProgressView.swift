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
    
    @IBOutlet weak var achievementImage: UIImageView!
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
        addSubview(contentView)
    }
    
    func setProgress(progress:Double) {
        
        let path = UIBezierPath(arcCenter: CGPoint(x: contentView.frame.origin.x + contentView.frame.width/2, y: contentView.frame.origin.y + contentView.frame.width/2), radius: contentView.frame.width/2, startAngle: CGFloat(-Double.pi/2), endAngle: CGFloat(3 * Double.pi/2), clockwise: true)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeStart = 0
        layer.strokeEnd = 1
        if (progress == 0.0) {
            layer.strokeColor = Color.purpleTrans.cgColor
        } else if (progress == 1.0) {
            layer.strokeColor = Color.green.cgColor
        } else {
            layer.strokeColor = Color.orange.cgColor
            layer.strokeEnd = progress
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
        }
        layer.lineWidth = 2
        layer.lineCap = .round
        contentView.layer.addSublayer(layer)
    }
}
