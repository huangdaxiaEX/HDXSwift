//
//  BlurTool.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/10/5.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

enum BlurType {
    case Normal
    case Band
    case Circle
}

struct BlurTools: ImageToolConfigurable {
    var iconImage: UIImage
    var title: String
    var isAvailable: Bool
    var imageEditor: ImageEditorViewController
    var toolType: ImageTools
    
    init(toolType: ImageTools, imageEditor: ImageEditorViewController) {
        self.toolType = toolType
        self.iconImage = toolType.iconImage()
        self.title = toolType.title()
        self.isAvailable = toolType.avaliable()
        self.imageEditor = imageEditor
    }
    
}
