//
//  String+Width.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/9.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

extension String {
    func widthWithFont(font: UIFont) -> CGFloat {
        return NSString(string: self).boundingRectWithSize(CGSize(width: CGFloat.max, height: CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size.width
    }
    
}