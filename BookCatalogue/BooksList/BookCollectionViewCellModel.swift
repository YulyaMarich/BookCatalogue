//
//  вре.swift
//  BookCatalogue
//
//  Created by Julia on 06.02.2023.
//

import Foundation
import SafariServices

protocol BookCollectionViewCellModelProtocol {
    var data: Book? { get }
    var title: String { get }
    var description: String { get }
    var author: String { get }
    var publisher: String { get }
    var bookImage: String { get }
    var rank: Int { get }
    var amazonProductUrl: String { get }
    var indexPath: IndexPath{ get }
}

class BookCollectionViewCellModel: BookCollectionViewCellModelProtocol {
    var indexPath: IndexPath
    
    var title: String {
        data?.title ?? "Mo info"
    }
    
    var description: String {
        data?.description ?? "Mo info"
    }
    
    var author: String {
        data?.author ?? "Mo info"
    }
    
    var publisher: String {
        data?.publisher ?? "Mo info"
    }
    
    var bookImage: String {
        data?.bookImage ?? "Mo info"
    }
    
    var rank: Int {
        data?.rank ?? 0
    }
    
    var amazonProductUrl: String {
        data?.amazonProductUrl ?? "Mo info"
    }
    
    var data: Book?
    
    init(data: Book?, indexPath: IndexPath) {
        self.data = data
        self.indexPath = indexPath
    }
}
