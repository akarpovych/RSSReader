//
//  NewsPosts.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/2/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import Foundation
import CoreData

@objc(NewsPosts)
public class NewsPosts: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsPosts> {
        return NSFetchRequest<NewsPosts>(entityName: "NewsPosts")
    }
    
    @NSManaged public var title: String?
    @NSManaged public var newsDescription: String?
    @NSManaged public var link: String?
    @NSManaged public var date: String?
    @NSManaged public var imageKey: String?
    @NSManaged public var dateFormatted: Date?
}
