//
//  ImageToolConfigurable.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/10/5.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

protocol ImageToolConfigurable {
    var iconImage: UIImage { get }
    var title: String { get }
    var isAvailable: Bool { get }
    var toolType: ImageTools { get }
    var imageEditor: ImageEditorViewController { get }
    
    init(toolType: ImageTools, imageEditor: ImageEditorViewController)
    func setup()
    func cleanup()
    func executeWithCompletionBlock(completion: (image: UIImage, error: NSError) -> Void)

}
