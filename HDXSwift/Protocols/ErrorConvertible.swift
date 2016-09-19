//
//  ErrorConvertible.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/19.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import Foundation

protocol ErrorConvertible: ErrorType {
    var domain: String { get }
    var reson: String { get }
    
    var rawVaule: Int { get }
    
    func error() -> NSError
}

extension ErrorConvertible {
    var reson: String {
        return "\(self)"
    }
    
    func error() -> NSError {
        return NSError(domain: domain, code: rawVaule, userInfo: [NSLocalizedDescriptionKey : reson])
    }
}
