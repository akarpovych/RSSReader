//
//  StoryboardLoadable.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/2/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import UIKit

protocol StoryboardLoadable {
    static func loadFromStoryboard(storyboardName: String?) -> Self
}

extension StoryboardLoadable where Self: UIViewController {
    static func loadFromStoryboard(storyboardName: String? = nil) -> Self {
        let storyboard = UIStoryboard(name: storyboardName ?? String(describing: Self.self), bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: Self.self)) as? Self ?? Self()
        
        return controller
    }
}
