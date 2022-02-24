//
//  HttpMethods.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import Foundation


typealias HTTPHeaders = [String: String]

typealias Parameters = [String: Any]

enum HTTPMethod: String {
    case get  = "GET"
    case post = "POST"
}
