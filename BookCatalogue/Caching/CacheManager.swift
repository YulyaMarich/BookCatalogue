//
//  CacheManager.swift
//  BookCatalogue
//
//  Created by Julia on 06.02.2023.
//

import Foundation
import UIKit

class CacheManager: CacheService {
    
    private let realm: Cacheble
    
    init(realm: Cacheble = RealmCache.instance) {
        self.realm = realm
    }
    
    func getDataFromCache<T: Codable>(for url: String, decodable: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        if let data = realm.cacheData(forURLString: url) {
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(decodable, from: data)
                
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getImageFromCache(for url: String) -> UIImage? {
        guard let data = realm.cacheData(forURLString: url), let image = UIImage(data: data) else { return nil }
        return image
    }
    
    func saveDataToCache(data: Data, for url: String) {
        realm.saveCache(data: data, forURLString: url)
    }
}
