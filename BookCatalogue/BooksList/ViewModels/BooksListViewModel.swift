//
//  BooksListViewModel.swift
//  BookCatalogue
//
//  Created by Julia on 02.02.2023.
//

import Foundation
import Combine

protocol BooksListViewModelProtocol {
    
    var listName: String { get }
    var errorPublisher: CurrentValueSubject<String?, Never> { get }
    var dataPublisher: CurrentValueSubject<[Book]?, Never> { get }
    
    func fetch()
}

class BooksListViewModel: BooksListViewModelProtocol {
    
    private var networkManager: NetworkService
    
    private var listNameEncoded: String
    
    var errorPublisher = CurrentValueSubject<String?, Never> (nil)
    
    var dataPublisher =  CurrentValueSubject<[Book]?, Never> (nil)
    
    var listName: String
    
    init(listNameEncoded: String, listName: String, networkManager: NetworkService = NetworkManager()) {
        self.listNameEncoded = listNameEncoded
        self.listName = listName
        self.networkManager = networkManager
    }
    
    func fetch() {
        networkManager.request(type: .booksList(listNameEncoded), decodable: BooksList.self) { result in
            switch result {
            case .success(let success):
                self.dataPublisher.value = success.results.books
            case .failure(let failure):
                self.errorPublisher.value = failure.asAFError?.underlyingError?.localizedDescription
            }
        }
    }
}
