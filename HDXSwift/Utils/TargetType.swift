//
//  TargetType.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/19.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import Foundation
import Alamofire

protocol TargetType {
    var baseURL: NSURL { get }
    var path: String { get }
    var method: Alamofire.Method { get }
    var parameters: [String : AnyObject]? { get }
}

extension TargetType {
    var URLString: String {
        return baseURL.URLByAppendingPathComponent(path)!.absoluteString!
    }
}
