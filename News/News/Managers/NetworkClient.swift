//
//  NetworkClient.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import Foundation


final class NetworkClient: NetworkProtocol {
    
    static let shared = NetworkClient()
    
    private init() {
        // one can initialize this class
    }
    
    private static let sessionManager: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = NetworkConstants.requestTimeout
        config.timeoutIntervalForResource = NetworkConstants.responseTimeOut
        return URLSession(configuration: config)
    }()
    
    private var task: URLSessionTask?
    
    func request<T: Codable>(routerRequest: URLRequestConvertible, type: T.Type,
                    completionHandler: @escaping (Result<T, NewsError>) -> ()) {
        do {
            let request = try routerRequest.asURLRequest()
            task = Self.sessionManager.dataTask(with: request) { data, response, error in
                guard let data = data,
                let parsedData = Utility.jsonParser(tyeof: type, data: data),
                    error == nil else {
                    completionHandler(.failure(.networkError))
                    return
                }
                completionHandler(.success(parsedData))
            }
        } catch {
            completionHandler(.failure(.invalidRequest))
        }
        task?.resume()
    }
}
