//
//  FilterTool.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/10/6.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

class FilterTool: ImageToolConfigurable {
    var originalImage: UIImage
    var thumnailImage: UIImage
    var toolList: [[String : AnyObject]]
    
    var filterScrollView: UIScrollView
    var iconImage: UIImage
    var title: String
    var isAvailable: Bool
    var imageEditor: ImageEditorViewController
    var toolType: ImageTools
    
    required init(toolType: ImageTools, imageEditor: ImageEditorViewController) {
        self.toolType = toolType
        self.iconImage = toolType.iconImage()
        self.title = toolType.title()
        self.isAvailable = toolType.avaliable()
        self.imageEditor = imageEditor
        self.toolList = toolType.toolList()!
        self.originalImage = imageEditor.imageView.image!
        self.thumnailImage = originalImage.aspectFill(CGSize(width: 50, height: 50))
        self.filterScrollView = UIScrollView(frame: imageEditor.menuScrollView.frame)
        filterScrollView.backgroundColor = imageEditor.menuScrollView.backgroundColor
        filterScrollView.showsHorizontalScrollIndicator = false
    }
    
    func setup() {
        imageEditor.menuScrollView.addSubview(filterScrollView)
        setFilterMenu()
        showFilterScrollView()
    }

    func showFilterScrollView() {
        filterScrollView.transform = CGAffineTransformMakeTranslation(0, self.imageEditor.view.height - filterScrollView.top)
        UIView.animateWithDuration(kCLImageToolAnimationDuration, animations: {
            self.filterScrollView.transform = CGAffineTransformIdentity
        })
    }
    
    func setFilterMenu() {
        let W: CGFloat = 70
        var X: CGFloat = 0
        
        for filter: [String : AnyObject] in toolList {
            let view = MenuPanelView(viewModel: filter, frame: CGRect(x: X, y: 0, width: W, height: W))

            let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            iconView.clipsToBounds = true
            iconView.layer.cornerRadius = 5
            iconView.contentMode = .ScaleAspectFill
            view.addSubview(iconView)
            
            let label = UILabel.label(12, textColor: .blackColor(), alignment: .Center)
            label.frame = CGRect(x: 0, y: W - 10, width: W, height: 15)
            label.text = filter["title"] as? String
            view.addSubview(label)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(FilterTool.didTappedFilterPanel(_:)))
            view.addGestureRecognizer(gesture)
            
            filterScrollView.addSubview(view)
            X = X + W

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let iconImage = self.filteredImage(self.thumnailImage, filterName: filter["name"] as! String)
                dispatch_async(dispatch_get_main_queue(), { 
                    iconView.image = iconImage
                })
            })
        }
        
        filterScrollView.contentSize = CGSizeMake(max(X, filterScrollView.frame.size.width + 1), 0)
    }
    
    @objc func didTappedFilterPanel(gesture: UITapGestureRecognizer) {
        guard let view: MenuPanelView = gesture.view as? MenuPanelView else {
            return
        }
        view.alpha = 0.2
        UIView.animateWithDuration(kCLImageToolAnimationDuration) { 
            view.alpha = 1

        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let image = self.filteredImage(self.originalImage, filterName: view.viewModel["name"] as! String)
            dispatch_async(dispatch_get_main_queue(), {
                self.imageEditor.imageView.image = image
            })
        })
    }
    
    func filteredImage(image: UIImage, filterName: String) -> UIImage {
        if filterName == "Original" {
            return originalImage
        }
        
        let ciImage = CIImage(image: image)
        let filer = CIFilter(name: filterName, withInputParameters: [kCIInputImageKey : ciImage!])
        filer?.setDefaults()
        
        if filterName == "CIVignetteEffect" {
            let R = min(image.size.width, image.size.height) * 0.5
            let vct = CIVector(x: image.size.width / 2, y: image.size.height / 2)
            filer?.setValue(vct, forKey: "inputCenter")
            filer?.setValue(NSNumber(double: 0.9), forKey: "inputIntensity")
            filer?.setValue(NSNumber(double: Double(R)), forKey: "inputRadius")
        }
        
        let context = CIContext(options: nil)
        let outputImage = filer?.outputImage
        let cgImage = context.createCGImage(outputImage!, fromRect: outputImage!.extent)
        
        return UIImage(CGImage: cgImage!)
    }
    
    func cleanup() {
        UIView.animateWithDuration(kCLImageToolAnimationDuration, animations: {
            self.filterScrollView.transform = CGAffineTransformMakeTranslation(0, self.imageEditor.view.height - self.filterScrollView.top)
            }) { (finished) in
                self.filterScrollView.removeFromSuperview()
        }
    }
    
    func executeWithCompletionBlock(completion: (image: UIImage, error: NSError) -> Void) {
       
    }

}
