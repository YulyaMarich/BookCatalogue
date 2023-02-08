//
//  вре.swift
//  BookCatalogue
//
//  Created by Julia on 06.02.2023.
//

import Foundation

protocol BookCollectionViewCellModelProtocol {
    
    var data: Book? { get }
    var cacheManager: CacheService { get }
    var title: String { get }
    var description: String { get }
    var author: String { get }
    var publisher: String { get }
    var bookImage: String { get }
    var rank: Int { get }
    var indexPath: IndexPath{ get }
    var buyLinks: [Link] { get }
}

class BookCollectionViewCellModel: BookCollectionViewCellModelProtocol {

    init(data: Book?, indexPath: IndexPath, cacheManager: CacheService = CacheManager()) {
        self.data = data
        self.indexPath = indexPath
        self.cacheManager = cacheManager
    }
    
    var buyLinks: [Link] {
        data?.buyLinks ?? []
    }
    
    let indexPath: IndexPath
    
    let cacheManager: CacheService
    
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
    
    let data: Book?
}
