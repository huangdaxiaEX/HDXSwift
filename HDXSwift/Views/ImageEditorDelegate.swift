//
//  ImageEditorDelegate.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/10/5.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

protocol ImageEditorDelegate: NSObjectProtocol {
    func imageEditor(editor: ImageEditorViewController, didFinishEdittingWithImage image: UIImage)
    func imageEditorDidCancel(editor: ImageEditorViewController)
}
