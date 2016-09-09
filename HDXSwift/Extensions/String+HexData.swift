//
//  String+HexData.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/9.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

extension String {
    var haxData: NSData? {
        return NSData(hexString: self.trim())
    }
    
}

