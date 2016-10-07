//
//  ClippingTool.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/10/5.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

class Ratio {
    var isLandscape: Bool = false
    var ratio: CGFloat {
        get {
            if longSide == 0 || shortSide == 0{
                return 0
            }
            
            if self.isLandscape {
                return CGFloat(shortSide / longSide)
            }
            
            return CGFloat(longSide / shortSide)
        }
    }
    
    var longSide: NSInteger
    var shortSide: NSInteger

    init(value1: NSInteger, value2: NSInteger) {
        self.longSide = max(labs(value1), labs(value2))
        self.shortSide = min(labs(value1), labs(value2))
    }
    
    func description() -> String {
        if longSide == 0 || shortSide == 0 {
            return "初始状态"
        }
        
        if isLandscape {
            return "\(longSide) : \(shortSide)"
        }
        
        return "\(shortSide) : \(longSide)"
    }
    
}

class GridLayar: CALayer {
    var clippingRect: CGRect?
    var bgColor: UIColor?
    var gridColor: UIColor?
    
    override func drawInContext(ctx: CGContext) {
        var rct = bounds
        CGContextSetFillColorWithColor(ctx, bgColor!.CGColor)
        CGContextFillRect(ctx, rct)
        
        CGContextClearRect(ctx, clippingRect!)
        
        CGContextSetStrokeColorWithColor(ctx, gridColor!.CGColor)
        CGContextSetLineWidth(ctx, 1)
        
        rct = clippingRect!
        
        CGContextBeginPath(ctx)
        var dW: CGFloat = 0
        for _ in 0..<4 {
            CGContextMoveToPoint(ctx, rct.origin.x + CGFloat(dW), rct.origin.y)
            CGContextAddLineToPoint(ctx, rct.origin.x + CGFloat(dW), rct.origin.y + rct.size.height)
            dW += clippingRect!.size.width / 3
        }
        
        dW = 0
        for _ in 0..<4 {
            CGContextMoveToPoint(ctx, rct.origin.x, rct.origin.y + CGFloat(dW))
            CGContextAddLineToPoint(ctx, rct.origin.x + rct.size.width, rct.origin.y + CGFloat(dW))
            dW += rct.size.height / 3
        }
        CGContextStrokePath(ctx);
    }
    
}

class ClippingCircle: UIView {
    var bgColor: UIColor = .whiteColor()
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        var rct = bounds
        rct.origin.x = rct.size.width / 2 - rct.size.width / 6
        rct.origin.y = rct.size.height / 2 - rct.size.height / 6
        rct.size.width /= 3
        rct.size.height /= 3
        
        CGContextSetFillColorWithColor(context!, bgColor.CGColor);
        CGContextFillEllipseInRect(context!, rct);
    }
    
}

enum ViewPosition: Int {
    case LeftTop = 1
    case LeftBottom
    case RightTop
    case RightBottom
}

class ClippingPanel: UIView {
    var clippingRect: CGRect!
    var clippingRatio: Ratio? {
        didSet {
            clippingRatioDidChange()
        }
    }
    
    var gridLayer: GridLayar = {
        let layer = GridLayar()
        layer.bgColor = UIColor.whiteColor()
        layer.gridColor = UIColor.blackColor()
        
        return layer
    } ()
    
    lazy var ltView: ClippingCircle = {
        return self.clippingCircleWithTag(.LeftTop)
    } ()
    lazy var lbView: ClippingCircle = {
        return self.clippingCircleWithTag(.LeftBottom)
    } ()
    
    lazy var rtView: ClippingCircle = {
        return self.clippingCircleWithTag(.RightTop)
    } ()
    
    lazy var rbView: ClippingCircle = {
        return self.clippingCircleWithTag(.RightTop)
    } ()
    
    init(superview: UIView, frame: CGRect) {
        super.init(frame: frame)
        
        superview.addSubview(self)
        layer.addSublayer(gridLayer)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ClippingPanel.panGridView(_:)))
        self.addGestureRecognizer(pan)
        clippingRect = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clippingCircleWithTag(tag: ViewPosition) -> ClippingCircle {
        let view = ClippingCircle(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        view.backgroundColor = .clearColor()
        view.bgColor = .blackColor()
        view.tag = tag.rawValue
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ClippingPanel.panCircleView(_:)))
        view.addGestureRecognizer(panGesture)
        
        superview?.addSubview(view)
        
        return view
    }
    
    func panCircleView(sender: UIPanGestureRecognizer) {
        var point = sender.locationInView(self)
        let dp = sender.translationInView(self)
        
        var rct = clippingRect
        
        let W = frame.width
        let H = frame.height
        var minX: CGFloat = 0
        var minY: CGFloat = 0
        var maxX: CGFloat = W
        var maxY: CGFloat = H
        
        let senderView = sender.view!
        let ratio = (senderView.tag == 1 || senderView.tag == 2) ? -clippingRatio!.ratio : clippingRatio!.ratio
        
        switch senderView.tag {
        case ViewPosition.LeftTop.rawValue:
            maxX = max((rct.origin.x + rct.size.width)  - 0.1 * W, 0.1 * W)
            maxY = max((rct.origin.y + rct.size.height) - 0.1 * H, 0.1 * H)
            
            if ratio != 0 {
                let y0 = rct.origin.y - ratio * rct.origin.x
                let x0 = -y0 / ratio
                minX = max(x0, 0)
                minY = max(y0, 0)
                point.x = max(minX, min(point.x, maxX))
                point.y = max(minY, min(point.y, maxY))
                
                if (dp.x * ratio + dp.y) > 0 {
                    point.x = (point.y - y0) / ratio
                } else {
                    point.x = max(minX, min(point.x, maxX))
                    point.y = max(minY, min(point.y, maxY))
                }
            } else {
                point.x = max(minX, min(point.x, maxX))
                point.y = max(minY, min(point.y, maxY))
            }
            rct.size.width  = rct.size.width  - (point.x - rct.origin.x)
            rct.size.height = rct.size.height - (point.y - rct.origin.y)
            rct.origin.x = point.x
            rct.origin.y = point.y
        case ViewPosition.LeftBottom.rawValue:
            maxX = max((rct.origin.x + rct.size.width)  - 0.1 * W, 0.1 * W)
            minY = max(rct.origin.y + 0.1 * H, 0.1 * H)
            
            if ratio != 0 {
                let y0 = (rct.origin.y + rct.size.height) - ratio * rct.origin.x
                let xh = (H - y0) / ratio
                minX = max(xh, 0)
                maxY = max(y0, H)
                
                point.x = max(minX, min(point.x, maxX))
                point.y = max(minY, min(point.y, maxY))
                
                if (-dp.x * ratio + dp.y) < 0 {
                    point.x = (point.y - y0) / ratio
                } else {
                    point.y = point.x * ratio + y0
                }
            } else {
                point.x = max(minX, min(point.x, maxX))
                point.y = max(minY, min(point.y, maxY))
            }
            
            rct.size.width = rct.size.width  - (point.x - rct.origin.x)
            rct.size.height = point.y - rct.origin.y
            rct.origin.x = point.x
        case ViewPosition.RightTop.rawValue:
            minX = max(rct.origin.x + 0.1 * W, 0.1 * W)
            maxY = max((rct.origin.y + rct.size.height) - 0.1 * H, 0.1 * H)
            
            if ratio != 0 {
                let y0 = rct.origin.y - ratio * (rct.origin.x + rct.size.width)
                let yw = ratio * W + y0
                let x0 = -y0 / ratio
                maxX = min(x0, W)
                minY = max(yw, 0)
                
                point.x = max(minX, min(point.x, maxX))
                point.y = max(minY, min(point.y, maxY))
                
                if (-dp.x*ratio + dp.y) > 0 {
                    point.x = (point.y - y0) / ratio
                } else {
                    point.y = point.x * ratio + y0
                }
            } else {
                point.x = max(minX, min(point.x, maxX))
                point.y = max(minY, min(point.y, maxY))
            }
            
            rct.size.width  = point.x - rct.origin.x
            rct.size.height = rct.size.height - (point.y - rct.origin.y)
            rct.origin.y = point.y
        case ViewPosition.RightBottom.rawValue:
            minX = max(rct.origin.x + 0.1 * W, 0.1 * W)
            minY = max(rct.origin.y + 0.1 * H, 0.1 * H)
            
            if ratio != 0 {
                let y0 = (rct.origin.y + rct.size.height) - ratio * (rct.origin.x + rct.size.width)
                let yw = ratio * W + y0
                let xh = (H - y0) / ratio
                maxX = min(xh, W)
                maxY = min(yw, H)
                
                point.x = max(minX, min(point.x, maxX))
                point.y = max(minY, min(point.y, maxY))
                
                if (-dp.x * ratio + dp.y) < 0 {
                    point.x = (point.y - y0) / ratio
                } else {
                    point.y = point.x * ratio + y0
                }
            } else {
                point.x = max(minX, min(point.x, maxX))
                point.y = max(minY, min(point.y, maxY))
            }
            
            rct.size.width  = point.x - rct.origin.x
            rct.size.height = point.y - rct.origin.y
        default:
            break
        }
        
    }
    
    var dragging = false
    var initialRect: CGRect?
    func panGridView(sender: UIPanGestureRecognizer) {
        dragging = false
        
        if sender.state == .Began {
            let point = sender.locationInView(self)
            dragging = CGRectContainsPoint(clippingRect, point)
            initialRect = clippingRect
        } else if dragging {
            let point = sender.translationInView(self)
            let left = min(max(initialRect!.origin.x + point.x, 0), frame.size.width - initialRect!.size.width)
            let top = min(max(initialRect!.origin.y + point.y, 0), frame.size.height - initialRect!.size.height)
            
            var rct = clippingRect
            rct.origin.x = left
            rct.origin.y = top
            clippingRect = rct
        }
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        ltView.removeFromSuperview()
        lbView.removeFromSuperview()
        rtView.removeFromSuperview()
        rbView.removeFromSuperview()
    }
    
    func setBgColor(bgColor: UIColor) {
        gridLayer.bgColor = bgColor
    }
    
    func setGridColor(gridColor: UIColor) {
        gridLayer.gridColor = gridColor
        
        let color = gridColor.colorWithAlphaComponent(1)
        ltView.bgColor = color
        lbView.bgColor = color
        rtView.bgColor = color
        rbView.bgColor = color
    }
    
    func setClippingRect(clipping: CGRect, animated: Bool) {
        if animated {
            UIView.animateWithDuration(kCLImageToolFadeoutDuration, animations: { 
                self.changeFrame()
            })
            
            let ani = CABasicAnimation(keyPath: "clippingRect")
            ani.duration = kCLImageToolFadeoutDuration
            ani.fromValue = NSValue(CGRect: clippingRect)
            ani.toValue = NSValue(CGRect: clipping)
            gridLayer.addAnimation(ani, forKey: nil)
            
            gridLayer.clippingRect = clipping
            self.clippingRect = clipping
            setNeedsDisplay()
        } else {
            self.clippingRect = clipping
            changeFrame()
            setNeedsDisplay()
        }
    }
    
    func changeFrame() {
        let sView = superview!
        ltView.center = sView.convertPoint(CGPoint(x: clippingRect.origin.x, y: clippingRect.origin.y), fromView: self)
        ltView.center = sView.convertPoint(CGPoint(x: clippingRect.origin.x, y: clippingRect.origin.y + clippingRect.height), fromView: self)
        ltView.center = sView.convertPoint(CGPoint(x: clippingRect.origin.x + clippingRect.width, y: clippingRect.origin.y), fromView: self)
        ltView.center = sView.convertPoint(CGPoint(x: clippingRect.origin.x + clippingRect.width, y: clippingRect.origin.y + clippingRect.height), fromView: self)
    }
    
    func clippingRatioDidChange() {
        var rect = bounds
        if let ratio = clippingRatio {
            let H = rect.size.width * ratio.ratio;
            if H <= rect.size.height {
                rect.size.height = H
            } else{
                rect.size.width *= rect.size.height / H
            }
            
            rect.origin.x = (bounds.size.width - rect.size.width) / 2
            rect.origin.y = (bounds.size.height - rect.size.height) / 2
        }
        setClippingRect(rect, animated: true)
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        
        gridLayer.setNeedsDisplay()
    }
    
}

class RatioMenuItem: View {
    var ratio: Ratio? {
        didSet {
            refreshViews()
        }
    }
    var iconView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        image.backgroundColor = UIColor.whiteColor()
        image.clipsToBounds = true
        image.contentMode = .ScaleAspectFill
        image.layer.cornerRadius = 3
        
        return image
    } ()
    
    var titleLabel: UILabel = {
        let lable = UILabel.label(10, textColor: .blackColor(), alignment: .Center)
        
        return lable
    } ()
    
    init(iconImage: UIImage, frame: CGRect) {
        iconView.image = iconImage
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        addSubview(iconView)
        addSubview(titleLabel)
    }
    
    func changeOrietation() {
        guard let ratio = ratio else {
            return
        }
        ratio.isLandscape = !ratio.isLandscape
        UIView.animateWithDuration(kCLImageToolFadeoutDuration) { 
            self.refreshViews()
        }
    }
    
    func refreshViews() {
        guard let ratio = ratio else {
            return
        }
        
        titleLabel.text = ratio.description()
        
        let center = iconView.center
        var W: CGFloat = 0
        var H: CGFloat = 0
        
        if ratio.ratio != 0 {
            if ratio.isLandscape {
                W = 50
                H = 50 * ratio.ratio
            } else {
                W = 50 / ratio.ratio
                H = 50
            }
        } else {
            let maxW = max(iconView.image!.size.width, iconView.image!.size.height)
            W = 50 * iconView.image!.size.width / maxW
            H = 50 * iconView.image!.size.height / maxW
        }
        iconView.frame = CGRect(x: center.x - W / 2, y: center.y - H / 2, width: W, height: H)
    }
    
}

class ClippingTool: ImageToolConfigurable {
    var iconImage: UIImage
    var title: String
    var isAvailable: Bool
    var toolType: ImageTools
    var imageEditor: ImageEditorViewController
    
    var gridView: ClippingPanel
    var menuContainer: UIView
    var menuScroll: UIScrollView
    var selectedMenu: RatioMenuItem? {
        willSet {
            selectedMenu?.backgroundColor = .clearColor()
        }
        didSet {
            selectedMenu?.backgroundColor = UIColor.cyanColor().colorWithAlphaComponent(0.2)
        }
    }
    
    required init(toolType: ImageTools, imageEditor: ImageEditorViewController) {
        self.toolType = toolType
        self.iconImage = toolType.iconImage()
        self.title = toolType.title()
        self.isAvailable = toolType.avaliable()
        self.imageEditor = imageEditor
        
        menuContainer = UIView(frame: imageEditor.menuScrollView.frame)
        menuScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: menuContainer.width - 70, height: menuContainer.height))
        gridView = ClippingPanel(superview: imageEditor.scrollView, frame: imageEditor.imageView.frame)
        setup()
    }
    
    func setup() {
        menuContainer.backgroundColor = imageEditor.menuScrollView.backgroundColor
        imageEditor.view.addSubview(menuContainer)
        
        menuScroll.backgroundColor = .clearColor()
        menuScroll.showsHorizontalScrollIndicator = false
        menuScroll.clipsToBounds = false
        menuContainer.addSubview(menuScroll)
        
        let btnPanel = UIView(frame: CGRect(x: menuScroll.right, y: 0, width: 70, height: menuContainer.height))
        btnPanel.backgroundColor = menuContainer.backgroundColor!.colorWithAlphaComponent(0.9)
        menuContainer.addSubview(btnPanel)
        
        let btn = UIButton(type: .Custom)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.center = CGPoint(x: btnPanel.width / 2, y: btnPanel.height / 2 - 10)
        btn.addTarget(self, action: #selector(pushedRotateBtn), forControlEvents: .TouchUpInside)
        btn.setImage(Images.Alpha, forState: .Normal)
        btn.adjustsImageWhenHighlighted = true
        btnPanel.addSubview(btn)
        
        gridView.backgroundColor = .clearColor()
        gridView.setBgColor(imageEditor.view.backgroundColor!.colorWithAlphaComponent(0.8))
        gridView.setGridColor(UIColor.darkGrayColor().colorWithAlphaComponent(0.8))
        gridView.clipsToBounds = false
    }
    
    @objc func pushedRotateBtn() {
        for item in menuScroll.subviews {
            if item.isKindOfClass(RatioMenuItem.self) {
                (item as! RatioMenuItem).changeOrietation()
            }
        }
        if gridView.clippingRatio?.ratio != 0 && gridView.clippingRatio?.ratio != 1 {
            gridView.clippingRatioDidChange()
        }
    }
    
    func setCropMenu() {
        let W: CGFloat = 70
        var X: CGFloat = 0
    
        let ratioList = [
            Ratio(value1: 0, value2: 0),
            Ratio(value1: 1, value2: 1),
            Ratio(value1: 4, value2: 3),
            Ratio(value1: 3, value2: 2),
            Ratio(value1: 16, value2: 9)
        ]
        let imageSize = imageEditor.imageView.image!.size
        let maxW = min(imageSize.width, imageSize.height)
        let iconImage = imageEditor.imageView.image!.resize(CGSize(width: 70 * imageSize.width / maxW, height: 70 * imageSize.height / maxW))
        
        for ratio in ratioList {
            ratio.isLandscape = imageEditor.imageView.image?.size.width > imageEditor.imageView.image?.size.height
            let view = RatioMenuItem(iconImage: iconImage, frame: CGRect(x: X, y: 0, width: W, height: menuScroll.height))
            view.ratio = ratio
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tappedMenu(_:)))
            view.addGestureRecognizer(tap)
            
            menuScroll.addSubview(view)
            
            X += W
            if selectedMenu == nil {
                self.selectedMenu = view
            }
        }
        
        menuScroll.contentSize = CGSize(width: max(X, menuScroll.frame.width + 1), height: 0)
    }
    
    @objc func tappedMenu(tap: UITapGestureRecognizer) {
        let view: RatioMenuItem = tap.view as! RatioMenuItem
        view.alpha = 0.2
        
        UIView.animateWithDuration(kCLImageToolAnimationDuration) { 
            view.alpha = 1
        }
        selectedMenu = view
        
        if view.ratio!.ratio == 0 {
            gridView.clippingRatio = nil
        } else {
            gridView.clippingRatio = view.ratio
        }
    }
    
    func cleanup() {
        imageEditor.resetZoomScaleWithAnimate(true)
        gridView.removeFromSuperview()
        
        UIView.animateWithDuration(kCLImageToolAnimationDuration, animations: { 
            self.menuContainer.transform = CGAffineTransformMakeTranslation(0, self.imageEditor.view.height - self.menuScroll.top)
            }) { (finished) in
                self.menuContainer.removeFromSuperview()
        }
    }
    
    func executeWithCompletionBlock(completion: (image: UIImage, error: NSError) -> Void) {
        
    }
}
