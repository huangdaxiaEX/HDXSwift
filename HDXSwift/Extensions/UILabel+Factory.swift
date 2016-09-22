//
//  UILabel+Factory.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/23.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

extension UILabel {
    class func label(fontSize: CGFloat = 16, bold: Bool = false, textColor: UIColor = UIColor.whiteColor(), alignment: NSTextAlignment = .Left, fitWith: Bool = true) -> UILabel {
        let label = UILabel()
        label.font = bold ? UIFont.boldSystemFontOfSize(fontSize) : UIFont.systemFontOfSize(fontSize)
        label.textColor = textColor
        label.textAlignment = alignment
        label.text = "Label"
        label.adjustsFontSizeToFitWidth = fitWith
        
        return label
    }
    
    func autoFontFits() {
        guard let text = text where text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 else {
            return
        }
        
        let toNSString = NSString(string: text)
        var fontSize = font.pointSize
        var textSize = toNSString.sizeWithAttributes([NSFontAttributeName: font])
        
        while textSize.height > bounds.height || textSize.width > bounds.width {
            fontSize -= 1
            font = UIFont.systemFontOfSize(fontSize)
            textSize = toNSString.sizeWithAttributes([NSFontAttributeName: font])
        }
    }

}
