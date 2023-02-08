//
//  NetworkManager.swift
//  BookCatalogue
//
//  Created by Julia on 04.02.2023.
//
import Foundation
import Alamofire

fileprivate struct NetworkConstants {
    static let apiKey = "api-key"
    static let url = "https://api.nytimes.com/svc/books/v3/lists/"
    static let categoriesListApiPath = "names"
}

class NetworkManager {
    
    private let key = "GmLTWtiAwPIGXu0QdqSZGznq3TJR2Hy2"
    
    private let cacheManager: CacheService
    
    init(cacheManager: CacheService = CacheManager()) {
        self.cacheManager = cacheManager
    }
    
    func request<T: Codable>(type: RequestType, decodable: T.Type, completion: @escaping (_ result: Result<T, Error>) -> Void) {
        let parameters = [NetworkConstants.apiKey: key]
        let url = NetworkConstants.url + type.apiPath
        
        cacheManager.getDataFromCache(for: url, decodable: decodable, completion: completion)
        
        let request = AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString))
        request.responseDecodable(of: decodable) { [ weak self ] response in
          
            switch response.result {
                   case .failure(let error):
                completion(.failure(error))
                   case .success(let data):
                guard let responseData = response.data else { return }
                self?.cacheManager.saveDataToCache(data: responseData, for: url)
                completion(.success(data))
                }
        }
    }
}

enum RequestType {
    case categoriesList
    case booksList(String)
    
    var apiPath: String {
        switch self {
        case .categoriesList:
            return NetworkConstants.categoriesListApiPath
        case .booksList(let encodedListName):
            return encodedListName
        }
    }
}



