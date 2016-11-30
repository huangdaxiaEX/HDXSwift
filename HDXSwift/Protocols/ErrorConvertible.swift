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
    
    var rawValue: Int { get }
    
    func error() -> NSError
}

extension ErrorConvertible {
    var reson: String {
        return "\(self)"
    }
    
    var rawValue: Int {
        return self.rawValue
    }
    
    func error() -> NSError {
        return NSError(domain: domain, code: rawValue, userInfo: [NSLocalizedDescriptionKey : reson])
    }
    
}
