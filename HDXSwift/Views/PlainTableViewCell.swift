//
//  PlainTableViewCell.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/23.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

struct PlainTabelViewCellModel {
    let image: UIImage
    let title: String?
    let attributedTitle: NSAttributedString?
    
    init(image: UIImage, title: String? = nil, attributedTitle: NSAttributedString? = nil) {
        self.image = image
        self.title = title
        self.attributedTitle = attributedTitle
    }
}

class PlainTableViewCell: UITableViewCell, CellViewModel {
    typealias ViewModel = PlainTabelViewCellModel
    var viewModel: ViewModel?
    
    func configure(viewModel: ViewModel) {
        self.viewModel = viewModel
        backgroundColor = UIColor.whiteColor()
        textLabel?.adjustsFontSizeToFitWidth = true
        let accessory = UIImageView(frame: CGRect(x: 0, y: 0, width: 8, height: 16))
        accessory.image = Images.CellAccessory
        accessoryView = accessory
        textLabel?.text = viewModel.title
        if let attributed = viewModel.attributedTitle {
            textLabel?.attributedText = attributed
        }
        imageView?.image = viewModel.image
    }
    
}
