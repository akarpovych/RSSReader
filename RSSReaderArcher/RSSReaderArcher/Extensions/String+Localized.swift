//
//  String+Localized.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/4/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import Foundation

extension String {
    func localized(_ comment: String = "none") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
