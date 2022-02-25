//
//  CountryHeadline.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import Foundation

protocol GenericProtocol { }

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    let sources: [Source]?
}

// MARK: - Article
struct Article: Codable, GenericProtocol {
    let source: Source?
    let author: String?
    let title, articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable, GenericProtocol {
    let id, name, sourceDescription: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case sourceDescription = "description"
        case url
    }
}
