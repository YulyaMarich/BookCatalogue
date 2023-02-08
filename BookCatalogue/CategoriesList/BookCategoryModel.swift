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
    let listNameEncoded: String
    
    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case updated
        case newestPublishedDate = "newest_published_date"
        case listNameEncoded = "list_name_encoded"
    }
}
