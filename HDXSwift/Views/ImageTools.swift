//
//  ImageTools.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/10/6.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

enum ImageTools {
    case Filter
    case Blur
    case Clipping
    case Effect
    case Adjustment
    case ToneCurve
    
    func iconImage() -> UIImage {
        switch self {
        case .Filter:
            return Images.Alpha
        case .Blur:
            return Images.Alpha
        case .Clipping:
            return Images.Alpha
        case .Effect:
            return Images.Alpha
        case .Adjustment:
            return Images.Alpha
        case .ToneCurve:
            return Images.Alpha
        }
    }
    
    func title() -> String {
        switch self {
        case .Filter:
            return "Filter"
        case .Blur:
            return "Blur"
        case .Clipping:
            return "Clipping"
        case .Effect:
            return "Effect"
        case .Adjustment:
            return "Adjustment"
        case .ToneCurve:
            return "ToneCurve"
        }
    }
    
    func avaliable() -> Bool {
        switch self {
        case .Filter, .Blur, .Clipping, .Effect, .Adjustment, .ToneCurve:
            return true
//        default:
//            return false
        }
    }
    
    func toolList() -> [[String : AnyObject]]? {
        switch self {
        case .Filter:
            return [
                ["name" : "Original", "title" : "Original"],
                ["name" : "CISRGBToneCurveToLinear", "title" : "Linear"],
                ["name" : "CIVignetteEffect", "title" : "Effect"],
                ["name" : "CIPhotoEffectInstant", "title" : "Instant"],
                ["name" : "CIPhotoEffectProcess", "title" : "Process"],
                ["name" : "CIPhotoEffectTransfer", "title" : "Transfer"],
                ["name" : "CISepiaTone", "title" : "Sepia"],
                ["name" : "CIPhotoEffectChrome", "title" : "Chrome"],
                ["name" : "CIPhotoEffectFade", "title" : "Fade"],
                ["name" : "CILinearToSRGBToneCurve", "title" : "Curve"],
                ["name" : "CIPhotoEffectTonal", "title" : "Tonal"],
                ["name" : "CIPhotoEffectNoir", "title" : "Noir"],
                ["name" : "CIPhotoEffectMono", "title" : "Mono"],
                ["name" : "CIColorInvert", "title" : "Invert"]
            ]
        default:
            return nil
        }
    }
}
