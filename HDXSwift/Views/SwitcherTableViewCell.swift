//
//  SwitcherTableViewCell.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/23.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

class SwitcherTableViewCell: UITableViewCell {
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
        accessoryView = switcher
        selectionStyle = .None
        textLabel?.textColor = UIColor.blackColor()
        backgroundColor = UIColor.whiteColor()
    }
    
}
