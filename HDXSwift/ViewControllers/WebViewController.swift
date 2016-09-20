//
//  WebViewController.swift
//  HDXSwift
//
//  Created by huangdaxia on 16/9/20.
//  Copyright © 2016年 huangdaxia. All rights reserved.
//

import UIKit
import Cartography

class WebViewController: ViewController {
    private var displayLink: CADisplayLink?
    private var progress: Float = 0.0
    
    var shouldShowShareItem: Bool = true
    var URLString: String?
    var URLRequest: NSURLRequest?
    var bottomMargin: CGFloat = 0
    var webTitle: String?
    var shareItemImage: UIImage?
 
    lazy var webView: UIWebView = { [unowned self] in
        let webView = UIWebView()
        webView.delegate = self
        webView.backgroundColor = .clearColor()
        webView.scrollView.backgroundColor = .clearColor()
        webView.scrollView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: self.bottomMargin, right: 0)
        
        return webView
    } ()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .Bar)
        progressView.trackTintColor = .clearColor()
        progressView.progressTintColor = Color.LandingCyan.color()
        progressView.autoresizingMask = [.FlexibleTopMargin, .FlexibleWidth]
        progressView.frame = CGRect(x: 0, y: 44, width: UIScreen.mainScreen().bounds.width, height: 2)
        progressView.progress = 0.0
        
        return progressView
    } ()
    
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reload), forControlEvents: .ValueChanged)
        
        return refresh
    } ()
    
    lazy var rightShareBarItem: UIBarButtonItem = { [unowned self] in
        let share = UIBarButtonItem(image: self.shareItemImage?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(didPressShareButton))
        
        return share
    } ()
    
    override func viewDidLoad() {
        shouldShowDismissBarButtonWhenNeeded = false
        super.viewDidLoad()
        
        if shouldShowShareItem {
            navigationItem.rightBarButtonItem = rightShareBarItem
        }
        
        view.addSubview(webView)
        webView.scrollView.addSubview(refreshControl)
        navigationController?.navigationBar.addSubview(progressView)
        automaticallyAdjustsScrollViewInsets = false
        
        if let URL = URLString {
            if !URL.isEmpty {
                URLRequest = NSURLRequest(URL: NSURL(string: URL)!)
            }
        }
        
        loadRequest()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        progressView.layoutIfNeeded()
        
    }
    
    func loadRequest() {
        if let request = URLRequest {
            webView.loadRequest(request)
            return
        }
    }
    
    func reload() {
        guard let request = webView.request where request.URL?.absoluteString!.characters.count > 10 else {
            loadRequest()
            return
        }
        webView.reload()
    }
    
    func stratProcess() {
        if displayLink != nil {
            return
        }
        if !webView.loading {
            return
        }
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkLoop))
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func stopProcess() {
        progress = 0.0
        progressView.progress = progress
        
        if displayLink != nil {
            displayLink?.invalidate()
            displayLink = nil
        }
    }
    
    func endProcess() {
        if let `displayLink` = displayLink {
            self.displayLink = nil
            progress = 0.0
            progressView.setProgress(1.0, animated: true)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0) * Int64(NSEC_PER_SEC)), dispatch_get_main_queue()) {[unowned self] () -> Void in
                self.progressView.progress = 0.0
                displayLink.invalidate()
            }
        }
    }
    
    func displayLinkLoop() {
        if displayLink == nil {
            return
        }
        
        if progress <= 0.6 {
            progress += 0.03
            progressView.progress = progress
            return
        }
        
        if progress <= 0.95 {
            progress += 0.003 / 60
            progressView.progress = progress
            return
        }
        
        displayLink?.invalidate()
        displayLink = nil
    }
    
    func didPressShareButton() {
    
    }
    
}

// MARK: UIWebViewDelegate

extension WebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        stratProcess()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        refreshControl.endRefreshing()
        endProcess()
        let titleJScript = "document.title"
        webTitle = webView.stringByEvaluatingJavaScriptFromString(titleJScript)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        refreshControl.endRefreshing()
        endProcess()
    }
    
}
