//
//  Layer+MaskLayer.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/10/5.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

extension CALayer {
    func maskLayerWithSize(size: CGSize, maskImage: UIImage) {
        let layer = CALayer()
        layer.anchorPoint = CGPoint.zero
        layer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        layer.contents = maskImage.CGImage
        self.mask = layer
    }

}

