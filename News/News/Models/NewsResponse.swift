//
//  CountryHeadline.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    let sources: [Source]?
    
//    enum CodingKeys: String, CodingKey {
//        case source = "sources"
//        case articles, totalResults, status
//    }
}

// MARK: - Article
struct Article: Codable {
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
struct Source: Codable {
    let id, name, sourceDescription: String?
    let url: String?
    let category: Category?
    let language: Language?
    let country: Country?

    enum CodingKeys: String, CodingKey {
        case id, name
        case sourceDescription = "description"
        case url, category, language, country
    }
}

enum Category: String, Codable {
    case business = "business"
    case entertainment = "entertainment"
    case general = "general"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"
}

enum Country: String, Codable {
    case us = "us"
}

enum Language: String, Codable {
    case en = "en"
    case es = "es"
}
