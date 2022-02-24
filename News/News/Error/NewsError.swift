//
//  NewsError.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import Foundation

enum NewsError: Error {
    case missingURL
    case parsingError
    case invalidStatusCode(String?, Int?)
    case dataEncodeingFailed
    case networkError
    case invalidRequest
}


