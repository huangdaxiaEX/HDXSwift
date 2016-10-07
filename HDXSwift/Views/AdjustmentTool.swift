//
//  AdjustmentTool.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/10/6.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

class AdjustmentTool: ImageToolConfigurable {
    var originalImage: UIImage
    var thumnailImage: UIImage
    
    var iconImage: UIImage
    var title: String
    var isAvailable: Bool
    var imageEditor: ImageEditorViewController
    var toolType: ImageTools
    
    private lazy var saturationSlider: UISlider = { [unowned self] in
        let slider: UISlider = self.sliderWithValue(1, minimumValue: 0, maximumValue: 2, action: #selector(AdjustmentTool.sliderDidChange(_:)))
        slider.superview?.center = CGPoint(x: self.imageEditor.view.frame.width / 2, y: self.imageEditor.menuScrollView.top - 30)
        slider.setThumbImage(Images.Alpha, forState: .Normal)
        
        return slider
    } ()
    
    private lazy var brightnessSlider: UISlider = { [unowned self] in
        let slider: UISlider = self.sliderWithValue(0, minimumValue: -1, maximumValue: 1, action: #selector(AdjustmentTool.sliderDidChange(_:)))
        slider.superview?.center = CGPoint(x: 20, y: self.saturationSlider.superview!.top - 30)
        slider.setThumbImage(Images.Alpha, forState: .Normal)
        slider.superview!.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI * 90 / 180.0))
        
        return slider
    } ()
    
    private lazy var contrastSlider: UISlider = { [unowned self] in
        let slider: UISlider = self.sliderWithValue(1, minimumValue: 0.5, maximumValue: 1.5, action: #selector(AdjustmentTool.sliderDidChange(_:)))
        slider.superview?.center = CGPoint(x: 300, y: self.brightnessSlider.superview!.centerY)
        slider.setThumbImage(Images.Alpha, forState: .Normal)
        slider.superview!.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI * 90 / 180.0))
        
        return slider
    } ()
    
    required init(toolType: ImageTools, imageEditor: ImageEditorViewController) {
        self.toolType = toolType
        self.iconImage = toolType.iconImage()
        self.title = toolType.title()
        self.isAvailable = toolType.avaliable()
        self.imageEditor = imageEditor
        
        self.originalImage = imageEditor.imageView.image!
        self.thumnailImage = originalImage.aspectFill(imageEditor.imageView.frame.size)
        
        setup()
    }
    
    func setup() {
        let _ = saturationSlider
        let _ = brightnessSlider
        let _ = contrastSlider
    }
    
    func cleanup() {
        saturationSlider.removeFromSuperview()
        brightnessSlider.removeFromSuperview()
        contrastSlider.removeFromSuperview()
        imageEditor.resetZoomScaleWithAnimate(true)
    }
    
    func executeWithCompletionBlock(completion: (image: UIImage, error: NSError) -> Void) {
        
    }
    
    func sliderWithValue(value: Float, minimumValue min: Float, maximumValue max: Float, action: Selector) -> UISlider {
        let slider = UISlider(frame: CGRect(x: 10, y: 0, width: 240, height: 35))
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 35))
        container.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        container.layer.cornerRadius = 35 * 0.5
        slider.continuous = true
        slider.addTarget(self, action: action, forControlEvents: .ValueChanged)
        slider.maximumValue = max
        slider.minimumValue = min
        slider.value = value
        container.addSubview(slider)
        imageEditor.view.addSubview(container)
        
        return slider
    }
    
    var inProgress = false
    @objc func sliderDidChange(slider: UISlider) {
        if inProgress {
            return
        }
        
        inProgress = true
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            let image = self.filteredImage(self.thumnailImage)
            dispatch_async(dispatch_get_main_queue(), { 
                self.imageEditor.imageView.image = image
                self.inProgress = false
            })
        }
    }
    
    func filteredImage(image: UIImage) -> UIImage {
        let ciImage = CIImage(image: image)
        var filter = CIFilter(name: "CIColorControls", withInputParameters: [kCIInputImageKey : ciImage!])
        filter?.setDefaults()
        filter?.setValue(NSNumber(float: saturationSlider.value), forKey: "inputSaturation")
        
        filter = CIFilter(name: "CIExposureAdjust", withInputParameters: [kCIInputImageKey : ciImage!])
        filter?.setDefaults()
        filter?.setValue(NSNumber(float: 2 * brightnessSlider.value), forKey: "inputEV")
        
        filter = CIFilter(name: "CIGammaAdjust", withInputParameters: [kCIInputImageKey : ciImage!])
        filter?.setDefaults()
        filter?.setValue(NSNumber(float: contrastSlider.value * contrastSlider.value), forKey: "inputPower")
        
        let context = CIContext(options: nil)
        let outputImage = (filter?.outputImage)!
        let cgImage = context.createCGImage(outputImage, fromRect: outputImage.extent)
        
        return UIImage(CGImage: cgImage!)
    }

    
}
