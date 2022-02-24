//
//  NetworkProtocol.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import Foundation

protocol NetworkProtocol {
    func request<T: Codable>(routerRequest: URLRequestConvertible,
                             type: T.Type,
                             completionHandler: @escaping(Result<T, NewsError>) -> ())
}
