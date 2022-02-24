//
//  HeadlinesRequest.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import Foundation


enum HeadlineRequest: URLRequestConvertible {
    
    case getHeadline(code: String, pageNo: Int)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getHeadline:
                return .get
            }
        }
        
        var params: Parameters {
            switch self {
            case .getHeadline(let code, let page):
                return [NetworkConstants.language: code,
                        NetworkConstants.page: page]
            }
        }
        
        var httpHeader: HTTPHeaders {
            switch self {
            case .getHeadline:
                return [NetworkConstants.auth: NetworkConstants.apiKey,
                        NetworkConstants.requestHeaderContentTypeKey : NetworkConstants.requestHeaderContentTypeValue]
            }
        }
        
        var url: URL {
            let url = URL(string: NetworkConstants.baseurl)!
            switch self {
            case .getHeadline:
                return url.appendingPathComponent(NetworkConstants.topHeadLinePath)
            }
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy:
                                            .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = httpHeader
        try Utility.encode(urlRequest: &urlRequest, with: params)
        return urlRequest
    }
}
