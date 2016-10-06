//
//  ImageEditor.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/10/5.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

class ImageEditor {
    var viewController: UINavigationController?
    weak var delegate: ImageEditorDelegate?
    
    init(image: UIImage) {
        self.viewController = NavigationController(rootViewController: ImageEditorViewController(image: image))
    }
}
