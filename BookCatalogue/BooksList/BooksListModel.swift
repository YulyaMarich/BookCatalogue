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
    let buyLinks: [Link]
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case author
        case publisher
        case bookImage = "book_image"
        case rank
        case buyLinks = "buy_links"
    }
}

struct Link: Codable {
    let name: String
    let url: String
}
