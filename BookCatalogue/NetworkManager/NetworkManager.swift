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
    
    func request<T: Codable>(type: RequestType, decodable: T.Type, completion:@escaping (_ result: Result<T, Error>) -> Void) {
        let parameters = [NetworkConstants.apiKey: key]
        let url = NetworkConstants.url + type.apiPath
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString)).responseDecodable(of: decodable) { response in
            guard let data = response.data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let data = try decoder.decode(decodable, from: data)
                completion(.success(data))
            } catch let jsonError {
                print("error : \(jsonError)")
                completion(.failure(jsonError))
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
        case .booksList(let string):
            return string
        }
    }
}



