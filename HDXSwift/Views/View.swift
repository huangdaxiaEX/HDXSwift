//
//  View.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/25.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit
import RxSwift

class View: UIView {
    var disposeBag = DisposeBag()
    var showBounds: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func drawRect(rect: CGRect) {
        if showBounds {
            let path = UIBezierPath(rect: rect)
            UIColor.redColor().setStroke()
            path.stroke()
        }
    }
}
