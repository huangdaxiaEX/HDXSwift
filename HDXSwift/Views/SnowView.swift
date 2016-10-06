//
//  SnowView.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/10/5.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

class SnowView: EmitterLayerView {
    var snowImage: UIImage?
    var lifeTime: Float = 30
    var birthRate: Float = 5
    var speed: CGFloat = 0
    var speedRange: CGFloat = 0
    var gravity: CGFloat = 0
    var snowColor: UIColor = .blackColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        emitterLayer.emitterShape = kCAEmitterLayerLine
        emitterLayer.emitterMode = kCAEmitterLayerSurface
        emitterLayer.emitterSize = frame.size
        emitterLayer.emitterPosition = CGPoint(x: bounds.width * 0.5, y: -5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configType(type: EmitterType) {
        snowImage = Images.Snow
        let imageView = UIImageView(frame: bounds)
        imageView.image = Images.Alpha
        maskView = imageView
        alpha = 0
    }
    
    override func show() {
        showSnow()
        
        UIView.animateWithDuration(1.75) { 
            self.alpha = 0.75
        }
    }
    
    override func hide() {
        UIView.animateWithDuration(1.75) {
            self.alpha = 0
        }
    }
    
    func showSnow() {
        guard let image = snowImage else {
            return
        }
        
        let snowFlake = CAEmitterCell()
        snowFlake.name = "snow"
        snowFlake.birthRate = birthRate > 0 ? birthRate : 1
        snowFlake.lifetime = lifeTime > 0 ? lifeTime : 60
        snowFlake.velocity = speed > 0 ? speed : 10.CGF()
        snowFlake.velocityRange = speedRange > 0 ? speedRange : 10.CGF()
        snowFlake.yAcceleration = gravity > 0 ? gravity : 2.CGF()
        snowFlake.emissionRange = CGFloat(0.5 * M_PI)
        snowFlake.spinRange = CGFloat(0.25 * M_PI)
        snowFlake.contents = image.CGImage
        snowFlake.color = snowColor.CGColor
        snowFlake.scale = 0.5
        snowFlake.scaleRange = 0.3
        emitterLayer.emitterCells = [snowFlake]
    }

}
