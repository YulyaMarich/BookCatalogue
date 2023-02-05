//
//  CategoriesListViewModel.swift
//  BookCatalogue
//
//  Created by Julia on 02.02.2023.
//

import Foundation

protocol CategoriesListViewModelProtocol {
    var networkManager: NetworkManager { get }
    var data: [Category]? { get set }
    
    func fetch(completion: @escaping() -> Void)
}

class CategoriesListViewModel: CategoriesListViewModelProtocol {
    var data: [Category]?
    
    var networkManager = NetworkManager()
    
    func fetch(completion: @escaping () -> Void) {
        networkManager.request(type: .categoriesList, decodable: CategoriesList.self) { result in
            switch result {
            case .success(let success):
                self.data = success.results
                completion()
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
