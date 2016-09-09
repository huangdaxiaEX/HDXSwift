//
//  String+Substraction.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/9.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

extension String {
    func substringToIndex(index: Int) -> String? {
        if index < 0 || index > characters.count { return nil }
        return substringToIndex(startIndex.advancedBy(index))
    }
    
    func substringByLength(length: Int) -> String {
        if length < 0 || characters.count <= length {
            return self
        }
        
        return substringToIndex(length)!
    }
    
}
