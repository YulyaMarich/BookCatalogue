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
    
    var buyLinks: [Link] {
        data?.buyLinks ?? []
    }
    
    var title: String {
        data?.title ?? "No info".localized()
    }
    
    var description: String {
        data?.description ?? "No info".localized()
    }
    
    var author: String {
        data?.author ?? "No info".localized()
    }
    
    var publisher: String {
        data?.publisher ?? "No info".localized()
    }
    
    var bookImage: String {
        data?.bookImage ?? "No info".localized()
    }
    
    var rank: Int {
        data?.rank ?? 0
    }
    
    let data: Book?
    
    let indexPath: IndexPath
    
    let cacheManager: CacheService
    
    init(data: Book?, indexPath: IndexPath, cacheManager: CacheService = CacheManager()) {
        self.data = data
        self.indexPath = indexPath
        self.cacheManager = cacheManager
    }
}
