//
//  CategoriesListViewModel.swift
//  BookCatalogue
//
//  Created by Julia on 02.02.2023.
//

import Foundation
import Combine

protocol CategoriesListViewModelProtocol {
    
    var networkManager: NetworkService { get }
    var data: [Category]? { get set }
    var errorPublisher: CurrentValueSubject<String?, Never> { get }

    func fetch(completion: @escaping() -> Void)
}

class CategoriesListViewModel: CategoriesListViewModelProtocol {
    
    init(networkManager: NetworkService = NetworkManager()) {
        self.networkManager = networkManager
    }
    var networkManager: NetworkService
    
    var errorPublisher = CurrentValueSubject<String?, Never> (nil)

    var data: [Category]?
    
    func fetch(completion: @escaping () -> Void) {
        networkManager.request(type: .categoriesList, decodable: CategoriesList.self) { result in
            switch result {
            case .success(let success):
                self.data = success.results
                completion()
            case .failure(let failure):
                self.errorPublisher.value = failure.asAFError?.underlyingError?.localizedDescription
                print(failure.localizedDescription)
            }
        }
    }
}
