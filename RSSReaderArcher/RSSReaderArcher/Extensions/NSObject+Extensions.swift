//
//  NSObject+Extensions.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/2/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import Foundation

public extension NSObject {
    
    var className: String {
        return NSStringFromClass(type(of: self))
    }
    
    class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
