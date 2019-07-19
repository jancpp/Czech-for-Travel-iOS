//
//  Category+CoreDataProperties.swift
//  Czech for Travel
//
//  Created by Jan Polzer on 7/16/19.
//  Copyright © 2019 Apps KC. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var imageFileName: String?
    @NSManaged public var name: String?
    @NSManaged public var index: Int16
    @NSManaged public var phrases: NSSet?

}

// MARK: Generated accessors for phrases
extension Category {

    @objc(addPhrasesObject:)
    @NSManaged public func addToPhrases(_ value: Phrase)

    @objc(removePhrasesObject:)
    @NSManaged public func removeFromPhrases(_ value: Phrase)

    @objc(addPhrases:)
    @NSManaged public func addToPhrases(_ values: NSSet)

    @objc(removePhrases:)
    @NSManaged public func removeFromPhrases(_ values: NSSet)

}
