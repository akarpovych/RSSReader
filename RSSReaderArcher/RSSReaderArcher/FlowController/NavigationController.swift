//
//  NavigationController.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/2/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    let backButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        self.setupNavigationBar()
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var prefersStatusBarHidden : Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape && UI_USER_INTERFACE_IDIOM() == .phone
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
    }
    
    @objc func backAction() {
        self.popViewController(animated: false)
    }
    
    private func setupNavigationBar() {
        self.navigationBar.barStyle = .black
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = UIColor.blue
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
    }
}
