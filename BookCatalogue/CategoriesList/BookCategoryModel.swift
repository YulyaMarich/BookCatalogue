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
}
