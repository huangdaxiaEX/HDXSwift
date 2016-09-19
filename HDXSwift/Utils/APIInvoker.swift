//
//  APIInvoker.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/19.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import Foundation
import Alamofire

private let processQueue = dispatch_queue_create("CommonAPIProcessQueue", DISPATCH_QUEUE_CONCURRENT)

struct APIInvoker {
    static func request(api: CommonAPI, userID: String, AESKey key: String? = nil) -> Alamofire.Request {
        var parameters: [String : AnyObject]
        if api.parameters == nil {
            parameters = [String : AnyObject]()
        } else {
            parameters = api.parameters!
        }
        
//        let postData = try! NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        
        return Alamofire.request(api.method, api.URLString, parameters: parameters, encoding: .JSON)
    }
    
}
