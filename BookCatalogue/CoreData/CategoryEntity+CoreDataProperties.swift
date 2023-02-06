//
//  CategoryEntity+CoreDataProperties.swift
//  BookCatalogue
//
//  Created by Julia on 06.02.2023.
//
//

import Foundation
import CoreData

public class CategoryEntity: NSManagedObject {
    @NSManaged public var listName: String?
    @NSManaged public var updateFrequency: String?
    @NSManaged public var newestPublishedDate: String?
}

