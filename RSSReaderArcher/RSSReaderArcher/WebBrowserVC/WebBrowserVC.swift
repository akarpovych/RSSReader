//
//  WebBrowserVC.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/2/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import UIKit
import WebKit

class WebBrowserVC: UIViewController, StoryboardLoadable {
    var newsURLString: String?
    var webView: WKWebView!
    var activityIndicator = UIActivityIndicatorView()
    
    
    static func makeViewController(url: String) -> WebBrowserVC {
        let vc = loadFromStoryboard()
        vc.newsURLString = url
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: self.view.bounds, configuration: WKWebViewConfiguration())
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activityIndicator.center = self.view.center
        activityIndicator.style = .gray
       
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
        self.webView.addObserver(self, forKeyPath:#keyPath(WKWebView.isLoading), options: .new, context: nil)
        guard let newsURL = self.newsURLString else { return }
        
        openWebSite(site: newsURL)

    }
    
    func openWebSite(site: String) {
        if let url = URL(string: site) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading"{
            if webView.isLoading {
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    

}
