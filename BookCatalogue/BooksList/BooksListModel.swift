//
//  BookModel.swift
//  BookCatalogue
//
//  Created by Julia on 05.02.2023.
//

import Foundation

struct BooksList: Codable {
    let results: ListInfo
}

struct ListInfo: Codable {
    let books: [Book]
}

struct Book: Codable {
    let title: String
    let description: String
    let author: String
    let publisher: String
    let bookImage: String
    let rank: Int
    let amazonProductUrl: String
}
