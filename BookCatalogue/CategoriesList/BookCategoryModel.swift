//
//  ListNamesModel.swift
//  BookCatalogue
//
//  Created by Julia on 05.02.2023.
//

import Foundation

struct CategoriesList: Codable {
    let results: [Category]
}

struct Category: Codable {
    let listName: String
    let updated: String
    let newestPublishedDate: String
    
    static let dataManager = CoreDataManager()
    
    func store() {
        guard let category = Category.dataManager.add(type: CategoryEntity.self) else { return }
        category.listName = listName
        category.updateFrequency = updated
        category.newestPublishedDate = newestPublishedDate
        Category.dataManager.save()
    }
}

