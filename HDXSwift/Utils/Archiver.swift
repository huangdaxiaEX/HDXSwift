//
//  Archiver.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/25.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import Foundation
import Gloss
import SwiftFilePath

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
    class func unarchiveFileAtPath(fullFilePath: String) -> Result<T, ArchiveError> {
        let filePath = Path(fullFilePath)
        
        if filePath.exists == false {
            return .Failure(.FileNotExisted)
        }
        
        guard let data = NSData(contentsOfFile: filePath.toString()),
            json = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String: AnyObject] else {
                return .Failure(.DataNotExisted)
        }
        
        guard let unarchived = T(json: json) else {
            return .Failure(.UnarchiveError)
        }
        
        return .Success(unarchived)
    }
    
    class func archiveFile(archivable: T, atPath path: String) -> ArchiveError? {
        let filePath = Path(path)
        let dirPath = filePath.parent
        
        if dirPath.exists == false {
            if dirPath.mkdir().isFailure {
                return .DirCreateError
            }
        }
        
        if filePath.exists == false {
            if filePath.touch().isFailure {
                return .DirCreateError
            }
        }
        
        guard let data = archivable.archived() where data.length != 0 else {
            return .DataNotExisted
        }
        
        if data.writeToFile(filePath.toString(), atomically: true) == false {
            return .SaveError
        }
        return nil
    }
}
