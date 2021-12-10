//
//  SearchResponse.swift
//  NewsApp
//
//  Created by Boris Bolshakov on 10.12.21.
//

import Foundation

struct SearchResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source?
    let author, title, articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
    
}

struct Source: Codable {
    let name: String
}
