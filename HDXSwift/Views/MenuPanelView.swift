//
//  MenuPanelView.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/10/6.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

class MenuPanelView: View {
    var viewModel: [String : AnyObject]
    
    init(viewModel: [String : AnyObject], frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
