//
//  SwitcherTableViewCell.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/23.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

struct SwitcherTableViewCellModel {
    let image: UIImage
    let title: String
    let on: Bool
    let switchClosure: (switcher: UISwitch) -> Void
    
    init(image: UIImage, title: String, on: Bool, switchClosure: (switcher: UISwitch) -> Void) {
        self.image = image
        self.title = title
        self.on = on
        self.switchClosure = switchClosure
    }
    
}

class SwitcherTableViewCell: UITableViewCell, CellViewModel {
    typealias ViewModel = SwitcherTableViewCellModel
    var viewModel: ViewModel?
    
    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = Color.CyanLight.color()
        
        return switcher
    } ()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        selectionStyle = .None
        textLabel?.textColor = UIColor.blackColor()
        backgroundColor = UIColor.whiteColor()
        accessoryView = switcher
        switcher.onTintColor = Color.CyanLight.color()
        switcher.addTarget(self, action: #selector(SwitcherTableViewCell.switchValueDidChange(_:)), forControlEvents: .ValueChanged)
    }
    
    func switchValueDidChange(switcher: UISwitch) {
        viewModel?.switchClosure(switcher: switcher)
    }
    
    func configure(viewModel: ViewModel) {
        self.viewModel = viewModel
        textLabel?.text = viewModel.title
        imageView?.image = viewModel.image
        switcher.setOn(viewModel.on, animated: false)
    }
}
