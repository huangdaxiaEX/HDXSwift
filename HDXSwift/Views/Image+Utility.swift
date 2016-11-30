//
//  Image+Utility.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/10/5.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit
import Accelerate

extension UIImage {
    class func decode(image: UIImage) -> UIImage {
        var img = image
        UIGraphicsBeginImageContext(image.size)
        img.drawAtPoint(CGPoint.zero)
        img = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return img
    }
    
    class func fastImageWithData(data: NSData) -> UIImage {
        let image = UIImage(data: data)!
        return decode(image)
    }
    
    class func fastImageWithContentsOfFile(path: String) -> UIImage {
        let image = UIImage(contentsOfFile: path)!
        return decode(image)
    }
    
    func deepCopy() -> UIImage {
        return UIImage.decode(self)
    }
    
    func resize(size: CGSize) -> UIImage {
        var W = size.width
        var H = size.height
        let imageRef = self.CGImage!
        let colorSpaceInfo = CGImageGetColorSpace(imageRef)!
        let bitmapInfo = CGImageGetBitmapInfo(imageRef)
        let bitMap = CGBitmapContextCreate(nil, Int(W), Int(H), 8, 4 * Int(W), colorSpaceInfo, bitmapInfo.rawValue)!
        if imageOrientation == .Left || imageOrientation == .Right {
            W = size.height
            H = size.width
        }
        if imageOrientation == .Left || imageOrientation == .LeftMirrored {
            CGContextRotateCTM(bitMap, CGFloat(M_PI / 2))
            CGContextTranslateCTM(bitMap, 0, -H)
        } else if imageOrientation == .Right || imageOrientation == .RightMirrored {
            CGContextRotateCTM(bitMap, CGFloat(-M_PI / 2))
            CGContextTranslateCTM(bitMap, -W, 0)
        } else if imageOrientation == .Up || imageOrientation == .UpMirrored {
            
        } else if imageOrientation == .Down || imageOrientation == .DownMirrored {
            CGContextTranslateCTM (bitMap, W, H)
            CGContextRotateCTM (bitMap, -CGFloat(M_PI))
        }
        
        CGContextDrawImage(bitMap, CGRect(x: 0, y: 0, width: W, height: H), imageRef)
        let ref = CGBitmapContextCreateImage(bitMap)
        let newImage = UIImage(CGImage: ref!)

        return newImage
    }
    
    func aspectFit(size: CGSize) -> UIImage {
        let ratio = min(size.width / self.size.width, size.height / self.size.height)
        return resize(CGSize(width: self.size.width * ratio, height: self.size.height * ratio))
    }
    
    func aspectFill(size: CGSize, offset: CGFloat = 0) -> UIImage {
        var W  = size.width
        var H  = size.height
        var W0 = self.size.width
        var H0 = self.size.height
        
        let imageRef = self.CGImage!
        let colorSpaceInfo = CGImageGetColorSpace(imageRef)!
        let bitmapInfo = CGImageGetBitmapInfo(imageRef)
//            CGBitmapInfo(rawValue: CGImageAlphaInfo.First.rawValue | CGBitmapInfo.ByteOrder32Little.rawValue)
  
        let bitMap = CGBitmapContextCreate(nil, Int(W), Int(H), 8, 4 * Int(W), colorSpaceInfo, bitmapInfo.rawValue)!
        
        if imageOrientation == .Left || imageOrientation == .Right {
            W = size.height
            H = size.width
            W0 = self.size.height
            H0 = self.size.width
        }
        
        let ratio = max(W / W0, H / H0)
        W0 = ratio * W0
        H0 = ratio * H0
        
        var dW = abs((W0 - W) / 2)
        var dH = abs((H0 - H) / 2)
        
        if dW == 0 {
            dH += offset
        }
        if dH == 0 {
            dW += offset
        }

        if imageOrientation == .Left || imageOrientation == .LeftMirrored {
            CGContextRotateCTM(bitMap, CGFloat(M_PI / 2))
            CGContextTranslateCTM(bitMap, 0, -H)
        } else if imageOrientation == .Right || imageOrientation == .RightMirrored {
            CGContextRotateCTM(bitMap, CGFloat(-M_PI / 2))
            CGContextTranslateCTM(bitMap, -W, 0)
        } else if imageOrientation == .Up || imageOrientation == .UpMirrored {
            
        } else if imageOrientation == .Down || imageOrientation == .DownMirrored {
            CGContextTranslateCTM (bitMap, W, H)
            CGContextRotateCTM (bitMap, -CGFloat(M_PI))
        }

        CGContextDrawImage(bitMap, CGRect(x: -dW, y: -dH, width: W0, height: H0), imageRef)
        let ref = CGBitmapContextCreateImage(bitMap)
        let newImage = UIImage(CGImage: ref!)
        
        return newImage
    }
    
    func crop(rect: CGRect) -> UIImage {
        let origin = CGPoint(x: -rect.origin.x, y:  -rect.origin.y)
        UIGraphicsBeginImageContext(CGSize(width: rect.size.width, height: rect.size.height))
        drawAtPoint(origin)
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    func maskedImage(image: UIImage) -> UIImage {
        let maskCG = image.CGImage!
        let mask = CGImageMaskCreate(
            CGImageGetWidth(maskCG),
            CGImageGetHeight(maskCG),
            CGImageGetBitsPerComponent(maskCG),
            CGImageGetBitsPerPixel(maskCG),
            CGImageGetBytesPerRow(maskCG),
            CGImageGetDataProvider(maskCG)!,
            nil,
            false)!
        
        let masked = CGImageCreateWithMask(self.CGImage!, mask)!

        return UIImage(CGImage: masked)
    }
    
//    func gaussBlur(blurLevel0: CGFloat) -> UIImage {
//        let blurLevel = min(1, max(0, blurLevel0))
//        var boxSize = blurLevel * 0.1 * min(self.size.width, self.size.height)
//        boxSize = boxSize - (boxSize % 2) + 1
//        let imageData = UIImageJPEGRepresentation(self, 1)
//        let tmpImage = UIImage(data: imageData!)
//        let img = (tmpImage?.CGImage)!
//        
//        var outBuffer: vImage_Buffer
//        var error: vImage_Error
//        var inProvider = CGImageGetDataProvider(img)
//        var inBitMapData = CGDataProviderCopyData(inProvider!)
//        
//        var inBuffer: vImage_Buffer = vImage_Buffer(data: UnsafeMutablePointer(CFDataGetBytePtr(inBitMapData)), height: UInt(CGImageGetHeight(img)), width: UInt(CGImageGetWidth(img)), rowBytes: CGImageGetBytesPerRow(img))
//
//        let windowR = boxSize / 2
//        var sig2 = windowR / 3.0
//        if windowR > 0 {
//            sig2 = -1 / (2 * sig2 * sig2)
//        }
//
//        let kernel = malloc(Int(boxSize) * sizeof(__int16_t))
//        var sum: __int32_t = 0
//        for i in 0..<Int(boxSize) {
//            kernel[i] = 255 * exp(sig2 * (Int(i) - Int(windowR)) * (Int(i) - Int(windowR)))
//            sum += kernel[i]
//        }
//        
//        error = vImageConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, kernel, boxSize, 1, sum, NULL, kvImageEdgeExtend);
//        error = vImageConvolve_ARGB8888(&outBuffer, &inBuffer, nil, 0, 0, kernel, 1, boxSize, sum, NULL, kvImageEdgeExtend)
//        outBuffer = inBuffer
//        
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let ctx = CGBitmapContextCreate(outBuffer.data,
//                                        Int(outBuffer.width),
//                                        Int(outBuffer.height),
//                                        8,
//                                        outBuffer.rowBytes,
//                                        colorSpace,
//                                        CGBitmapInfo.AlphaInfoMask.rawValue & CGImageAlphaInfo.NoneSkipLast.rawValue)
//        let imageRef = CGBitmapContextCreateImage(ctx!)
//        
//        let returnImage = UIImage(CGImage: imageRef!)
//        
//        return returnImage
//    }
    
}
