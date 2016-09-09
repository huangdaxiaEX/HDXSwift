//
//  String+Trim.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/9.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

extension String {
    func trim() -> String {
        return self.stringByReplacingOccurrencesOfString(" ", withString: "")
    }
    
}