//
//  Button.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/24.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

class Button: UIButton {
    let animationDuration: NSTimeInterval = 0.15
    
    var shouleChangeAlphaWhenDisabled: Bool = true
    var shouldAnimateWhenStateChanged: Bool = true
    
    override var enabled: Bool {
        didSet {
            setEnabled(enabled, animated: shouldAnimateWhenStateChanged)
        }
    }
    
    func setEnabled(enabled: Bool, animated: Bool) {
        self.enabled = enabled
        if shouleChangeAlphaWhenDisabled {
            let aplha: CGFloat = enabled ? 1.0 : 0.5
            UIView.animateWithDuration(animationDuration, animations: { 
                self.alpha = aplha
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        exclusiveTouch = true
    }
    
}

class FlatButton: Button {
    override var selected: Bool {
        didSet {
            
        }
    }
    
    override var highlighted: Bool {
        didSet {
            
        }
    }
    
    private var backgroundColors: [UInt : UIColor] = [:]
    private var borderColors: [UInt : UIColor] = [:]
    
    private override func setup() {
        titleLabel?.font = UIFont.systemFontOfSize(13)
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: titleLabel, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: titleLabel, attribute: .CenterY, multiplier: 1, constant: 0))
        layer.masksToBounds = true
        layer.borderWidth = 1.0
    }
    
    override func setEnabled(enabled: Bool, animated: Bool) {
        super.setEnabled(animated, animated: animated)
        changeColorsForStateChangeAnimated(animated)
    }
    
    func setSelected(selected: Bool, animated: Bool = false) {
        super.selected = selected
        changeColorsForStateChangeAnimated(animated)
    }
    
    func setHighlighted(highlightd: Bool, animated: Bool = false) {
        super.highlighted = highlighted
        changeColorsForStateChangeAnimated(animated)
    }
    
    func setBackgroundColor(backgroundColor: UIColor?, forState state: UIControlState, animated: Bool = false) {
        backgroundColors[state.rawValue] = backgroundColor
        if state == self.state {
            changeColorsForStateChangeAnimated(animated)
        }
    }
    
    func setBorderColor(borderColor: UIColor, forState state: UIControlState, animated: Bool = false) {
        borderColors[state.rawValue] = borderColor
        if state == self.state {
            changeColorsForStateChangeAnimated(animated)
        }
    }
    
    private func changeColorsForStateChangeAnimated(animated: Bool) {
        changeBackgroundColorForStateChangeAnimated(animated)
        changeBorderColorForStateChangeAnimated(animated)
    }
    
    private func changeBackgroundColorForStateChangeAnimated(animated: Bool) {
        if layer.backgroundColor == nil {
            layer.backgroundColor = UIColor.clearColor().CGColor
        }
        
        let newBackgroundColor = backgroundColors[state.rawValue] ?? backgroundColors[UIControlState.Normal.rawValue]
        guard let color = newBackgroundColor else {
            return
        }
        
        if color == UIColor(CGColor: layer.backgroundColor!) {
            return
        }
        
        if animated {
            animateLayer(layer, fromColor: layer.backgroundColor!, toColor: color.CGColor, forKey: "backgroundColor")
        }
        layer.backgroundColor = color.CGColor
    }
    
    private func changeBorderColorForStateChangeAnimated(animated: Bool) {
        if layer.borderColor == nil {
            layer.borderColor = UIColor.clearColor().CGColor
        }
        
        let newBorderColor = borderColors[state.rawValue] ?? borderColors[UIControlState.Normal.rawValue]
        guard let color = newBorderColor else {
            return
        }
        
        if color == UIColor(CGColor: layer.borderColor!) {
            return
        }
        
        if animated {
            animateLayer(layer, fromColor: layer.borderColor!, toColor: color.CGColor, forKey: "borderColor")
        }
        layer.borderColor = color.CGColor
    }
    
    private func animateLayer(layer: CALayer, fromColor: CGColorRef, toColor: CGColorRef, forKey: String) {
        let fade = CABasicAnimation()
        fade.fromValue = fromColor
        fade.toValue = toColor
        fade.duration = animationDuration
        layer.addAnimation(fade, forKey: forKey)
    }
    
}

class GyanButton: FlatButton {
    private override func setup() {
        super.setup()
        
        titleLabel?.font = UIFont.systemFontOfSize(16)
        setBackgroundColor(Color.CyanLight.color(), forState: .Normal)
        setBackgroundColor(Color.CyanLight.color().darkerColor(), forState: .Highlighted)
        setBackgroundColor(Color.CyanLight.color().transaparentByAlpha(0.5), forState: .Disabled)
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        layer.borderWidth = 1
    }
    
}

class SwitchButton: GyanButton {
    var on: Bool = false {
        didSet {
            switchColor()
        }
    }
    
    convenience init(isOn: Bool) {
        self.init()
        self.on = isOn
    }
    
    func switchColor() {
        if on {
            setBackgroundColor(Color.CyanLight.color(), forState: .Normal)
        } else {
            setBackgroundColor(Color.CellSelectedColor.color(), forState: .Normal)
        }
    }
    
    func setButtonOn(on: Bool) {
        self.on = on
    }

}

class BottomLineButton: UIButton {
    override func drawRect(rect: CGRect) {
        let textRect = titleLabel!.frame
        let contextRef = UIGraphicsGetCurrentContext()
        
        CGContextSetStrokeColorWithColor(contextRef!, (titleLabel?.textColor.CGColor)!)
        CGContextMoveToPoint(contextRef!, textRect.origin.x, textRect.origin.y + textRect.height)
        CGContextAddLineToPoint(contextRef!, textRect.origin.x + textRect.width, textRect.origin.y + textRect.height)
        CGContextClosePath(contextRef!)
        CGContextDrawPath(contextRef!, CGPathDrawingMode.Stroke)
    }
}
