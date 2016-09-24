//
//  CommonAPI.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/19.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import Foundation
import Alamofire

enum CommonAPI {
    case GetData
    case GetDataByUser(userID: String)
    case Default
}

extension CommonAPI: TargetType {
    var baseURL: NSURL {
        return NSURL(string: "www.baseURL.com")!
    }
    
    var path: String {
        switch self {
        case .GetData:
            return "getDataPath"
        case .GetDataByUser(_):
            return "getDataByUserPath"
        default:
            return "default"
        }
    }
    
    var method: Alamofire.Method {
        return .POST
    }
    
    var parameters: [String : AnyObject]? {
        switch self {
        case .GetData:
            return ["key" : "value"]
        default:
            return nil
        }
    }
    
}

// MARK: error

extension CommonAPI {
    enum Error: Int, ErrorConvertible {
        case UnknownError = -1
        case RequestTimeOut = -2
        
        var domain: String {
            return "CommonAPIErrorDomain"
        }
        
        var reson: String {
            switch self {
            case .UnknownError:
                return Localizations.UnknownError
            default:
                return Localizations.Huangdaxia
            }
        }
        
        var rawValue: Int {
            return self.rawValue
        }
    }
}

// MARK: request

private let processQueue = dispatch_queue_create("CommonAPIProcessQueue", DISPATCH_QUEUE_CONCURRENT)

extension CommonAPI {
    typealias APIResponse = Result<[String : AnyObject], NSError>
    typealias APIResponseClosure = (response: APIResponse) -> Void
    
    static func request(api: CommonAPI, userID: String, queue: dispatch_queue_t = dispatch_get_main_queue(), response: APIResponseClosure) -> Alamofire.Request {
        return APIInvoker.request(api, userID: userID).responseJSON(queue: processQueue, completionHandler: { result in
           
        })
    }
}


