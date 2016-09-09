//
//  Color.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/9.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit
import DynamicColor

enum Color: UInt32 {
    case LandingCyan = 0x1bc296
    case CyanLight = 0x08cfa8
    case Cyan = 0x00aea4
    case CyanAccent = 0x007770
    case CyanDunkel = 0x004635
    
}

extension Color {
    func color() -> UIColor {
        return UIColor(hex: self.rawValue)
    }
    
}

extension UIColor {
    func transaparentByAlpha(alpha: CGFloat) -> UIColor {
        let components = toRGBAComponents()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: alpha)
    }
    
}