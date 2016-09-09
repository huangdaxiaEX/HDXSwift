//
//  String+Version.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/9.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

extension String {
    func largerThanOrEqualToVersion(version: String) -> Bool {
        return compareVersion(version) != .OrderedAscending
    }
    
    func largerThanVersion(version: String) -> Bool {
        return compareVersion(version) == .OrderedDescending
    }
    
    func compareVersion(version: String) -> NSComparisonResult? {
        var leftVersions = self.componentsSeparatedByString(".").flatMap { Int($0) }
        var rightVersions = version.componentsSeparatedByString(".").flatMap { Int($0) }
        
        if leftVersions.isEmpty || rightVersions.isEmpty {
            return nil
        }
        
        let diff = leftVersions.count - rightVersions.count
        if diff > 0 {
            for _ in 0..<diff {
                rightVersions.append(0)
            }
        } else if diff < 0 {
            for _ in 0..<(-diff) {
                leftVersions.append(0)
            }
        }
        
        for index in 0..<leftVersions.count {
            if index >= rightVersions.count {
                return .OrderedDescending
            }
            
            let left = leftVersions[index]
            let right = rightVersions[index]
            
            if left < right {
                return .OrderedAscending
            } else if left > right {
                return .OrderedDescending
            }
        }
        
        return .OrderedSame
    }
    
}
