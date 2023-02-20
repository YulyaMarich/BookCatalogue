//
//  CategoriesListViewModel.swift
//  BookCatalogue
//
//  Created by Julia on 02.02.2023.
//

import Foundation
import Combine

protocol CategoriesListViewModelProtocol {
    
    var errorPublisher: CurrentValueSubject<String?, Never> { get }
    var dataPublisher: CurrentValueSubject<[Category]?, Never> { get }
    
    func fetch()
}

class CategoriesListViewModel: CategoriesListViewModelProtocol {
    
    private var networkManager: NetworkService
    
    var errorPublisher = CurrentValueSubject<String?, Never> (nil)
    
    var dataPublisher =  CurrentValueSubject<[Category]?, Never> (nil)
    
    init(networkManager: NetworkService = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetch() {
        networkManager.request(type: .categoriesList, decodable: CategoriesList.self) { result in
            switch result {
            case .success(let success):
                self.dataPublisher.value = success.results
            case .failure(let failure):
                self.errorPublisher.value = failure.asAFError?.underlyingError?.localizedDescription
            }
        }
    }
}
