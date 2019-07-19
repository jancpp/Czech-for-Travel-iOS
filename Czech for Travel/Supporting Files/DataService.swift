//
//  DataService.swift
//  Czech for Travel
//
//  Created by Jan Polzer on 6/24/19.
//  Copyright © 2019 Apps KC. All rights reserved.
//

import Foundation
import CoreData

class DataService {
    
    private let moc: NSManagedObjectContext
    private var regionList = [Category]()
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    // returns a list of categories
    func getCategories() -> [Category] {
        
        var categories = [Category]()
        var categoryNames = [String]()
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try moc.fetch(request)
        } catch  {
            fatalError("Error fetching categories")
        }
        
        for category in categories {
            if !categoryNames.contains(category.name!) {
                categoryNames.append(category.name!)
            }
        }
        
        return categories
    }

}
