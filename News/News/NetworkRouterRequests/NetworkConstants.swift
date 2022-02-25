//
//  NetworkConstants.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import Foundation

struct NetworkConstants {
    
    static let baseurl = "https://newsapi.org/v2/"
    static let apiKey = "af267181e3da412ea61b240954c8067e"
    static let countryKey = "country"
    static let auth = "Authorization"
    static let topHeadLinePath = "top-headlines"
    static let language = "language"
    static let requestHeaderContentTypeValue = "application/json"
    static let requestHeaderContentTypeKey = "Content-Type"
    static let page = "page"
    static let sourcePath = "top-headlines/sources"
    
    // MARK: - Request Timeout
    static let requestTimeout = 60.0
    static let responseTimeOut = 40.0
}
