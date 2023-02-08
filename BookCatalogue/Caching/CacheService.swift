//
//  CacheService.swift
//  BookCatalogue
//
//  Created by Julia on 08.02.2023.
//

import UIKit

protocol CacheService {
    
    func getDataFromCache<T: Codable>(for url: String, decodable: T.Type, completion: @escaping (Result<T, Error>) -> Void)
    func saveDataToCache(data: Data, for url: String)
    func getImageFromCache(for url: String) -> UIImage?
}
