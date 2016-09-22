//
//  TextFieldTableViewCell.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/23.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .Right
        textField.textColor = UIColor.blackColor()
        
        return textField
    } ()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = UIColor.whiteColor()
        let cellBackgroundView = UIView(frame: frame)
        cellBackgroundView.backgroundColor = Color.CellSelectedColor.color()
        selectedBackgroundView = cellBackgroundView
        
        self.textLabel?.textColor = UIColor.blackColor()
        addSubview(textField)
    }
    
}
