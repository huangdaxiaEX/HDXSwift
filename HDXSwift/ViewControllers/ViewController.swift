//
//  ViewController.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/9.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cartography
import DynamicColor

class ViewController: UIViewController {
    typealias KeyboardFrameChangeActionClosure = (duration: Int, curev: UInt, keyboardEndFrame: NSValue) -> Void
    var keyboardSubscription: RxSwift.Disposable?
    var keyboardFrameChange: KeyboardFrameChangeActionClosure?
    var tapBackground: UITapGestureRecognizer?
    
    let ratio: CGFloat = UIScreen.mainScreen().bounds.width / 375
    let screenWidth = UIScreen.mainScreen().bounds.width

    var shouldDismissKeyboardWhenTapped = false
    var shouldShowDismissBarButtonWhenNeeded = true
    
    lazy var disposeBag = DisposeBag()
    
    lazy var backgroundImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        
        return imageView
    } ()
    
    lazy var topMargin: CGFloat = { [unowned self] in
        if self.navigationController?.navigationBar.hidden == true {
            return 0
        }
        return 64
    } ()
    
    private var navBarVisualEffectView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = Color.LandingCyan.color()
        view.addSubview(backgroundImageView)
        
        if shouldDismissKeyboardWhenTapped {
            addTapGestureToDismissKeyboard()
        }
        
        if shouldShowDismissBarButtonWhenNeeded {
            setupDismissBarButtonItem()
        }
    }
    
    private var inset = false
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        if automaticallyAdjustsScrollViewInsets && !inset {
            inset = true
            if view.subviews.count > 1 {
                if let v = view.subviews[1] as? UIScrollView {
                    v.contentInset = UIEdgeInsets(top: (navigationController?.navigationBar.bounds.height ?? 0) + 20, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 0, right: 0)
                    v.contentOffset = CGPoint(x: 0, y: -v.contentInset.top)
                }
            }
        }
        
        view.setNeedsUpdateConstraints()
        
        if let `keyboardFrameChange` = keyboardFrameChange {
            keyboardSubscription?.dispose()
            keyboardSubscription = NSNotificationCenter.defaultCenter().rx_notification(UIKeyboardWillChangeFrameNotification)
                .subscribeNext({ note in
                    guard let userInfo = note.userInfo,
                        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Int,
                        curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt,
                        keyboardEndFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue
                        else {
                            return
                    }
                    keyboardFrameChange(duration: duration, curev: curve, keyboardEndFrame: keyboardEndFrame)
                })
        }
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        constrain(backgroundImageView, view) { (background, superview) -> () in
            background.edges == superview.edges
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    func applyBlackNavBar() {
        applyNavBarByColor(.blackColor())
    }
    
    func applyNavBarByColor(color: UIColor, barStyle: UIBarStyle = .Black, effectStyle: UIBlurEffectStyle = .Dark, tintColor: UIColor = .whiteColor()) {
        assert(self.navigationController != nil && self.navigationController is NavigationController, "Method should be used in NavigationController's viewControllers")
        
        let navigationBar = navigationController?.navigationBar
        let image = UIImage.imageWithColor(color)
        
        guard let navBar = navigationBar else {
            return
        }
        
        navBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = image
        
        navBar.translucent = true
        navBar.barStyle = barStyle
        navBar.tintColor = tintColor
        
        if #available(iOS 10, *) {
            return
        }
        if let views = navigationBar?.subviews {
            for view in views {
                if view is UIVisualEffectView {
                    view.removeFromSuperview()
                }
            }
        }
        let blurEffect = UIBlurEffect(style: effectStyle)
        navBarVisualEffectView = UIVisualEffectView(effect: blurEffect)
        navBarVisualEffectView!.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        let statusBarHeight: CGFloat = 20
        navBarVisualEffectView!.frame = CGRect(x: 0, y: -statusBarHeight, width: navBar.width, height: navBar.height + statusBarHeight)
        navBarVisualEffectView!.userInteractionEnabled = false
        navBar.insertSubview(navBarVisualEffectView!, atIndex: 0)
        
    }
    
    func applyTransparentNavBar() {
        let navigationBar = navigationController?.navigationBar
        let image = UIImage()
        navigationBar?.setBackgroundImage(image, forBarMetrics: .Default)
        navigationBar?.shadowImage = image
        navigationBar?.barStyle = .Black
        navigationBar?.translucent = true
        navigationBar?.tintColor = UIColor.whiteColor()
        navigationBar?.tintColor = UIColor.whiteColor()
        if let views = navigationBar?.subviews {
            for view in views {
                if view is UIVisualEffectView {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    func setupDismissBarButtonItem() -> Bool {
        if let _ = self.presentingViewController {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.ButtonDismiss, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.didPressDismissBarButtonItem))
            return true
        }
        
        return false
    }
    
    func addTapGestureToDismissKeyboard() {
        tapBackground = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard(_:)))
        tapBackground!.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapBackground!)
    }
    
    func dismissKeyboard(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func didPressDismissBarButtonItem() {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

class NavigationController: UINavigationController {

}
