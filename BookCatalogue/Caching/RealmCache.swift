//
//  RealmCache.swift
//  BookCatalogue
//
//  Created by Julia on 06.02.2023.
//

import UIKit
import RealmSwift

class RealmCacheItem: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var data: Data? = nil
    override class func primaryKey() -> String? {
        return "url"
    }
}

protocol Cacheble {
    
    func cacheData(forURLString url: String) -> Data?
    func saveCache(data: Data, forURLString url: String)
}

class RealmCache: Cacheble {
    
    static let instance = RealmCache()
    
    private let realm = try! Realm()
    
    func cacheData(forURLString url: String) -> Data? {
        let cache = realm.object(ofType: RealmCacheItem.self, forPrimaryKey: url)
        guard let cache = cache else {
            return nil
        }
        return cache.data
    }
    
    func saveCache(data: Data, forURLString url: String) {
        let cache = realm.object(ofType: RealmCacheItem.self, forPrimaryKey: url)
        if let cache = cache {
            write {
                cache.data = data
            }
        } else {
            let newItem = RealmCacheItem()
            write {
                newItem.data = data
                newItem.url = url
                realm.add(newItem)
            }
        }
    }
    
    private func write(_ completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
