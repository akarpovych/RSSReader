//
//  FlowController.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/2/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import Foundation

import UIKit

public enum Routers {
    case mainScreen
    case generalInformation(news: NewsPosts)
    case webBrowserScreen(url: String)
    case imageScreen(image: UIImage)
}

class FlowController {
    
    let navigationController: NavigationController
    
    init(navigationController: NavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showModule(.mainScreen)
    }
    
    func showModule(_ module: Routers) {
        switch module {
        case .mainScreen:
            let vc = MainVC.makeViewController(delegate: self)
            navigationController.pushViewController(vc, animated: true)
            
        case .generalInformation(let news):            
            let vc = InformationVC.makeViewController(delegate: self, news: news)
            navigationController.pushViewController(vc, animated: true)
       
        case .imageScreen(let image):
            let vc = ImageVC(image: image)
            navigationController.pushViewController(vc, animated: false)
            
        case .webBrowserScreen(let url):
            let vc = WebBrowserVC.makeViewController(url: url)
            navigationController.pushViewController(vc, animated: true)
        }
    }
}

extension FlowController: MainVCDelegate {
    func openNewsPressed(news: NewsPosts) {
        self.showModule(.generalInformation(news: news))
    }
    
    func openImageScreen(image: UIImage) {
        self.showModule(.imageScreen(image: image))
    }
}

extension FlowController: InformationVCDelegate {
    func openInWeb(url: String) {
        self.showModule(.webBrowserScreen(url: url))
    }
}
