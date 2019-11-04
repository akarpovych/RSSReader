//
//  UITableView+Reusable.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/2/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import UIKit

public extension UITableView {
    final func register<T: UITableViewCell>(_ cellType: T.Type)
        where T: Reusable {
            self.register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func register<T: UITableViewCell>(_ cellType: T.Type)
        where T: Reusable & NibLoadable {
            self.register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func register<T: UITableViewHeaderFooterView>(_ headerFooterViewType: T.Type)
        where T: Reusable & NibLoadable {
            self.register(headerFooterViewType.nib, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
    }
    
    func register(cellClass: AnyClass) {
        self.register(cell: String(describing: cellClass))
    }
    
    func register(cell: String) {
        let nib = UINib.init(nibName: cell, bundle: nil)
        self.register(nib, forCellReuseIdentifier: cell)
    }
}
