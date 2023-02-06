//
//  BookEntity+CoreDataProperties.swift
//  BookCatalogue
//
//  Created by Julia on 06.02.2023.
//
//

import Foundation
import CoreData

public class BookEntity: NSManagedObject {
    @NSManaged public var title: String?
    @NSManaged public var bookDescription: String?
    @NSManaged public var author: String?
    @NSManaged public var publisher: String?
    @NSManaged public var bookImage: String?
    @NSManaged public var rank: Int16
    @NSManaged public var amazonProductUrl: String?
}

