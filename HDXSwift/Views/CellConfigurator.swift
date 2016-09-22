//
//  CellConfigurator.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/22.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

protocol CellConfigurable {
    var reuseIdentifier: String { get }
    var cellClass: AnyClass { get }
    var height: CGFloat { get }
    var selectedAction: Selectable? { get }
    
    func configure(cell: UITableViewCell)
}

protocol CellViewModel {
    associatedtype ViewModel
    var viewModel: ViewModel? { get }
    
    func configure(viewModel: ViewModel)
}

struct CellConfigurator<Cell: UITableViewCell where Cell: CellViewModel>: CellConfigurable {
    let reuseIdentifier: String = NSStringFromClass(Cell)
    let cellClass: AnyClass = Cell.self
    let height: CGFloat
    let selectedAction: Selectable?
    let viewModel: Cell.ViewModel
    
    init(viewModel: Cell.ViewModel, height: CGFloat = 44, selectedAction: Selectable? = nil) {
        self.viewModel = viewModel
        self.height = height
        self.selectedAction = selectedAction
    }
    
    func configure(cell: UITableViewCell) {
        if let cell = cell as? Cell {
            cell.configure(viewModel)
        }
    }
}

struct SelectedAction: Selectable {
    var selectedClosure: (indexPath: NSIndexPath) -> Void
    
    init(selectedClosure: (indexPath: NSIndexPath) -> Void) {
        self.selectedClosure = selectedClosure
    }
    
    func didSelected(indexPath: NSIndexPath) {
        selectedClosure(indexPath: indexPath)
    }
}

struct PushToViewControllerWhenSelected: Selectable {
    weak var navigatorionController: UINavigationController?
    let viewControllerType: UIViewController.Type
    
    init(navigatorionController: UINavigationController, viewControllerType: UIViewController.Type) {
        self.navigatorionController = navigatorionController
        self.viewControllerType = viewControllerType
    }
    
    func didSelected(indexPath: NSIndexPath) {
        let vc = viewControllerType.init()
        vc.hidesBottomBarWhenPushed = true
        navigatorionController?.pushViewController(vc, animated: true)
    }
}
