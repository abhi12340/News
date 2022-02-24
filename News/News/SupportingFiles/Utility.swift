//
//  Utility.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import Foundation

struct Utility {
    
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters, isSortedDesc: Bool = false) throws {
        guard let url = urlRequest.url else {throw  NewsError.missingURL}
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for(key, value) in parameters.sorted(by: { isSortedDesc ? $0.key > $1.key :  $0.key < $1.key}) {
                let queryItem = URLQueryItem(name: key, value: "\(value)"
                                                .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
    }
    
    static func jsonParser<T: Codable>(tyeof: T.Type, data: Data) -> T? {
        do {
            let object = try JSONDecoder().decode(tyeof.self, from: data)
            return object
        } catch let parsingError {
            print(parsingError)
            return nil
        }
    }
    
   static func encode<T: Codable>(urlRequest: inout URLRequest,
                                          with object: T)  throws {
        do {
            let jsonData = try JSONEncoder().encode(object.self)
            urlRequest.httpBody = jsonData
        } catch {
            throw NewsError.dataEncodeingFailed
        }
    }
}
