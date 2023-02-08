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
    var data: [Book]? { get set }
    var errorPublisher: CurrentValueSubject<String?, Never> { get }
    
    func fetch(completion: @escaping() -> Void)
}

class BooksListViewModel: BooksListViewModelProtocol {
        
    private var networkManager: NetworkService
    
    private var listNameEncoded: String
 
    var errorPublisher = CurrentValueSubject<String?, Never> (nil)
    
    var data: [Book]?
    
    var listName: String
    
    init(listNameEncoded: String, listName: String, networkManager: NetworkService = NetworkManager()) {
        self.listNameEncoded = listNameEncoded
        self.listName = listName
        self.networkManager = networkManager
    }

    func fetch(completion: @escaping () -> Void) {
        networkManager.request(type: .booksList(listNameEncoded), decodable: BooksList.self) { result in
            switch result {
            case .success(let success):
                self.data = success.results.books
                completion()
            case .failure(let failure):
                self.errorPublisher.value = failure.asAFError?.underlyingError?.localizedDescription
            }
        }
    }
}
