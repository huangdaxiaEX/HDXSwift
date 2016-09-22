//
//  SliderTableViewCell.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/23.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit
import Cartography

class SliderTableViewCell: UITableViewCell {
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 30
        slider.minimumTrackTintColor = Color.CyanLight.color()
        
        return slider
    } ()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel.label()
        
        return label
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
        addSubview(slider)
        addSubview(contentLabel)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        constrain(slider, contentLabel, self) { (slider, label, superview) -> () in
            slider.top == superview.top + 8
            slider.leading == superview.leading + 30
            slider.trailing == superview.trailing - 30
            
            label.leading == superview.leading + 15
            label.trailing == superview.trailing - 15
            label.bottom == superview.bottom - 8
        }
    }
}
