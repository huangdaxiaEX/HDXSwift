//
//  ImageEditorViewController.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/10/5.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit

let kCLImageToolAnimationDuration = 0.3
let kCLImageToolFadeoutDuration = 0.2

class ImageEditorViewController: ViewController, UIScrollViewDelegate {

    private weak var delegate: ImageEditorDelegate?
    
    var originalImage: UIImage
    
    var imageView: UIImageView = UIImageView()
    
    var scrollView: UIScrollView = UIScrollView()
    
    lazy var menuScrollView: UIScrollView = { [unowned self] in
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    } ()
    
    init(image: UIImage) {
        self.originalImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.interactivePopGestureRecognizer?.enabled = false
        
        setupMenu()
    }
    
    func setupMenu() {
        let W: CGFloat = 70
        var X: CGFloat = 0
        
        for tool in ImageToolModel.list() {
            let view = UIView(frame: CGRect(x: X, y: 0, width: W, height: W))
            
            let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            iconView.image = tool.iconImage
            view.addSubview(iconView)
            
            let label = UILabel.label(12, textColor: .blackColor(), alignment: .Center)
            label.frame = CGRect(x: 0, y: W - 10, width: W, height: 15)
            label.text = tool.title
            view.addSubview(label)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(ImageEditorViewController.didTappedMenuView(_:)))
            view.addGestureRecognizer(gesture)
            
            menuScrollView.addSubview(view)
            X = X + W
        }
        menuScrollView.contentSize = CGSize(width: max(X, menuScrollView.frame.size.width + 1), height: 0)
    }
    
    func didTappedMenuView(gesture: UITapGestureRecognizer) {
        let view = gesture.view!
        view.alpha = 0.2
        
        UIView.animateWithDuration(kCLImageToolAnimationDuration) { 
            view.alpha = 1
        }
    }
    
    func resetImageViewFrame() {
        dispatch_async(dispatch_get_main_queue()) { 
            var rect = self.imageView.frame
            rect.size = CGSize(width: self.scrollView.zoomScale * self.imageView.image!.size.width, height: self.scrollView.zoomScale * self.imageView.image!.size.height)
            self.imageView.frame = rect
        }
    }
    
    func resetZoomScaleWithAnimate(animated: Bool) {
        dispatch_async(dispatch_get_main_queue()) {
            let RW = self.scrollView.frame.size.width / self.imageView.image!.size.width
            let RH = self.scrollView.frame.size.height / self.imageView.image!.size.height
            let ratio = min(RW, RH)
            self.scrollView.contentSize = self.imageView.frame.size
            self.scrollView.minimumZoomScale = ratio
            self.scrollView.maximumZoomScale = max(ratio / 240, 1 / ratio)
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: animated)
        }
    }
    
    func refreshImageView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.imageView.image = self.originalImage
            self.resetImageViewFrame()
            self.resetZoomScaleWithAnimate(false)
        }
    }
    
    func setCurrentTool() {
        //
        //    - (void)setCurrentTool:(CLImageToolBase *)currentTool
        //    {
        //    if(currentTool != _currentTool){
        //    [_currentTool cleanup];
        //    _currentTool = currentTool;
        //    [_currentTool setup];
        //
        //    [self swapToolBarWithEditting:(_currentTool!=nil)];
        //    }
        //    }
    }
 
    func swapMenuViewWithEditting(editting: Bool) {
        UIView.animateWithDuration(kCLImageToolAnimationDuration) { 
            if editting {
                self.menuScrollView.transform = CGAffineTransformMakeTranslation(0, self.view.height - self.menuScrollView.top)
            } else {
                self.menuScrollView.transform = CGAffineTransformIdentity
            }
        }
    }
    
    func swapToolBarWithEditting(editting: Bool) {
//        [self swapNavigationBarWithEditting:editting];
        swapMenuViewWithEditting(editting)
//        if(self.currentTool){
//            UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:[[self.currentTool class] title]];
//            item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(pushedDoneBtn:)];
//            item.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(pushedCancelBtn:)];
//            [_navigationBar pushNavigationItem:item animated:(self.navigationController==nil)];
//        }
//        else{
//            [_navigationBar popNavigationItemAnimated:(self.navigationController==nil)];
//        }
    }
    
    func pushedFinishedBtn() {
        guard let delegate = self.delegate else {
            return
        }
        delegate.imageEditor(self, didFinishEdittingWithImage: originalImage)
    }
    
    func pushedCancelBtn() {
        guard let delegate = self.delegate else {
            return
        }
        delegate.imageEditorDidCancel(self)
    }
    
    
    // MARK: ScrollView delegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(scrollView: UIScrollView) {
        let Ws = scrollView.frame.width
        let Hs = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        let W = originalImage.size.width * scrollView.zoomScale
        let H = originalImage.size.height * scrollView.zoomScale
        
        var rct = imageView.frame
        rct.origin.x = max((Ws - W) / 2, 0)
        rct.origin.y = max((Hs - H) / 2, 0)
        imageView.frame = rct
    }
    
}
