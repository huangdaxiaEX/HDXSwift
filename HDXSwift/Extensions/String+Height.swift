//
//  String+Height.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/9.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

extension String {
    func heightWithFont(font: UIFont, width: CGFloat) -> CGFloat {
        return NSString(string: self).boundingRectWithSize(CGSize(width: width, height: CGFloat.max), options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: [NSFontAttributeName: font], context: nil).size.height + 2
    }

}
