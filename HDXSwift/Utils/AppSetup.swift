//
//  AppSetup.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/19.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import Foundation
import SwiftyBeaver

let log = SwiftyBeaver.self

enum AppTarget {
    case Test
    case GM
    case Production
    
    var channelID: String {
        switch self {
        case .Test:
            return ""
        case .GM:
            return ""
        case.Production:
            return ""
        }
    }
        
}

class AppSetup {
    let bundleVersion = (NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] ?? "UnkownVersion") as! String
    
    var isDebugging: Bool
    let target: AppTarget
    
    static let shareInstance: AppSetup = AppSetup()
    
    private init() {
        target = .Production
        isDebugging = true
        
        setupLogger()
    }
    
    private func setupLogger() {
        if isDebugging {
            log.addDestination(ConsoleDestination())
        }
        log.debug("")
    }
    
    class func isChinese() -> Bool {
        if let langs = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages") as? [String] {
            if langs.first?.hasPrefix("zh") == true {
                return true
            }
        }
        
        return false
    }
    
}
