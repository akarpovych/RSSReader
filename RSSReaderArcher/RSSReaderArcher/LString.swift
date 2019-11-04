//
//  LString.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/4/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import Foundation

enum LString: String {
    case OFFLINE
    case THIS_DEVICE_IS_OFFLINE
    case CANCEL
    case GENERAL_INFO
    case DESCRIPTION
    case TITLE
    case DATE
    case OPEN_IN_WEB
    case NO_NEWS
    case NO_NEW_MESSAGE
    
    var TITLE: String {
        return rawValue.uppercased().localized()
    }
}
