//
//  BooksListViewModel.swift
//  BookCatalogue
//
//  Created by Julia on 02.02.2023.
//

import Foundation
import Combine

protocol BooksListViewModelProtocol {
    var networkManager: NetworkManager { get }
    var listName: String { get }
    var listNameEncoded: String { get }
    var data: [Book]? { get set }
    var errorPublisher: CurrentValueSubject<String?, Never> { get }
    
    func fetch(completion: @escaping() -> Void)
}

class BooksListViewModel: BooksListViewModelProtocol {
    var errorPublisher = CurrentValueSubject<String?, Never> (nil)

    init(listNameEncoded: String, listName: String) {
        self.listNameEncoded = listNameEncoded
        self.listName = listName
    }
    
    var listNameEncoded: String
    
    var data: [Book]?
    
    var listName: String
    
    var networkManager = NetworkManager()
    
    func fetch(completion: @escaping () -> Void) {
        networkManager.request(type: .booksList(listNameEncoded), decodable: BooksList.self) { result in
            switch result {
            case .success(let success):
                self.data = success.results.books
                completion()
            case .failure(let failure):
                self.errorPublisher.value = failure.asAFError?.underlyingError?.localizedDescription
                print(failure)
            }
        }
    }
}
