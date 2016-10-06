//
//  LaunchView.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/10/5.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

class LaunchView: View {
    
    let titleLabel: UILabel = UILabel.label()
    var snowView: SnowView!
    
    override func setup() {
        super.setup()
        userInteractionEnabled = false
        setupSnow()
        
        addSubview(snowView)
    }
    
    func setupSnow() {
        snowView = SnowView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width * 0.5, height: UIScreen.mainScreen().bounds.height * 0.5))
        snowView.birthRate = 20
        snowView.gravity = 5
        snowView.snowColor = .whiteColor()
        snowView.layer.maskLayerWithSize(CGSize(width: snowView.frame.width, height: snowView.frame.height), maskImage: Images.Alpha)
        snowView.showSnow()
        snowView.transform = CGAffineTransform(a: 1.4, b: 0, c: 0, d: 1.4, tx: 0, ty: 0)
        snowView.alpha = 0
    }
    
    func show() {
        UIView.animateWithDuration(1) { 
            self.snowView.alpha = 1
            self.snowView.transform = CGAffineTransform(a: 1.0, b: 0, c: 0, d: 1.0, tx: 0, ty: 0)
        }
    }
    
    func hide() {
        UIView.animateWithDuration(0.75, animations: { 
            self.snowView.alpha = 0
            self.snowView.transform = CGAffineTransform(a: 0.7, b: 0, c: 0, d: 0.7, tx: 0, ty: 0)
            }) { (finished) in
                self.snowView.transform = CGAffineTransform(a: 1.4, b: 0, c: 0, d: 1.4, tx: 0, ty: 0)
        }
    }
    
}
