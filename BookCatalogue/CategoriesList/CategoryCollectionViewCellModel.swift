//
//  CategoryCollectionViewCellModel.swift
//  BookCatalogue
//
//  Created by Julia on 05.02.2023.
//

import Foundation

protocol CategoryCollectionViewCellModelProtocol {
    var data: Category? { get }
    var listName: String { get }
    var updated: String { get }
    var newestPublishedDate: String { get }
}

class CategoryCollectionViewCellModel: CategoryCollectionViewCellModelProtocol {
    var listName: String {
        data?.listName ?? "No info"
    }
    
    var updated: String {
        data?.updated.localized() ?? "Mo info"
    }
    
    var newestPublishedDate: String {
        data?.newestPublishedDate ?? "No info"
    }
    
    var data: Category?
    
    init(data: Category?) {
        self.data = data
    }
}
