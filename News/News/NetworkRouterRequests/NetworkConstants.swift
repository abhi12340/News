//
//  NetworkConstants.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import Foundation

struct NetworkConstants {
    
    static let baseurl = "https://newsapi.org/v2/"
    static let apiKey = "003f1c335263477db2205467b22ec644"
    static let countryKey = "country"
    static let auth = "Authorization"
    static let topHeadLinePath = "top-headlines"
    static let language = "language"
    static let requestHeaderContentTypeValue = "application/json"
    static let requestHeaderContentTypeKey = "Content-Type"
    static let page = "page"
    static let sourcePath = "top-headlines/sources"
    static let sourceKey = "sources"
    static let searchKey = "q"
    
    // MARK: - Request Timeout
    static let requestTimeout = 30.0
    static let responseTimeOut = 30.0
}
