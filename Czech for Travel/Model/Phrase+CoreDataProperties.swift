//
//  Phrase+CoreDataProperties.swift
//  Czech for Travel
//
//  Created by Jan Polzer on 7/16/19.
//  Copyright © 2019 Apps KC. All rights reserved.
//
//

import Foundation
import CoreData


extension Phrase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Phrase> {
        return NSFetchRequest<Phrase>(entityName: "Phrase")
    }

    @NSManaged public var audioFileName: String?
    @NSManaged public var czech: String?
    @NSManaged public var czechDetail: String?
    @NSManaged public var english: String?
    @NSManaged public var position: Int16
    @NSManaged public var category: Category?

}
