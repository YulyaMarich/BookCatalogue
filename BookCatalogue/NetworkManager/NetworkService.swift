//
//  NetworkService.swift
//  BookCatalogue
//
//  Created by Julia on 08.02.2023.
//

import Foundation

protocol NetworkService {
    
    func request<T: Codable>(type: RequestType, decodable: T.Type, completion: @escaping (_ result: Result<T, Error>) -> Void)
}
