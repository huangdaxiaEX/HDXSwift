//
//  Archiver.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/25.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import Foundation
import Gloss

enum ArchiverError: Int, ErrorConvertible {
    case UnknownError
    case ParseError
    case DirCreateError
    case FileNotExistedError
    case ArchiverError
    case UnarchiveError
    case DataNotExisted
    case SaveError
    
    var domain: String {
        return "ArchiverError"
    }
    
}

protocol Archivable: Decodable, Encodable {
    func archived() -> NSData?
}

extension Archivable {
    func archived() -> NSData? {
        guard let json = toJSON() else { return nil }
        
        return NSKeyedArchiver.archivedDataWithRootObject(json)
    }
    
}

class Archiver<T: Archivable> {
    
}
