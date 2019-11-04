//
//  UIViewController+Extensions.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/4/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showEmptyNewsAlert() {
        let title = LString.NO_NEWS.TITLE
        let message = LString.NO_NEW_MESSAGE.TITLE
        let cancelAction = UIAlertAction(title: LString.CANCEL.TITLE, style: .default) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showOfflineAlert() {
        let title = LString.OFFLINE.TITLE
        let message = LString.THIS_DEVICE_IS_OFFLINE.TITLE
        
        let cancelAction = UIAlertAction(title: LString.CANCEL.TITLE, style: .default) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
