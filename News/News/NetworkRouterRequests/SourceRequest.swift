//
//  SourceRequest.swift
//  News
//
//  Created by Abhishek Kumar on 25/02/22.
//

import Foundation

enum SourceRequest: URLRequestConvertible {
    
    case getNewsSource(code: String, pageNo: Int)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getNewsSource:
                return .get
            }
        }
        
        var params: Parameters {
            switch self {
            case .getNewsSource(let code, let page):
                return [NetworkConstants.countryKey: code,
                        NetworkConstants.page: page]
            }
        }
        
        var httpHeader: HTTPHeaders {
            switch self {
            case .getNewsSource:
                return [NetworkConstants.auth: NetworkConstants.apiKey,
                        NetworkConstants.requestHeaderContentTypeKey : NetworkConstants.requestHeaderContentTypeValue]
            }
        }
        
        var url: URL {
            let url = URL(string: NetworkConstants.baseurl)!
            switch self {
            case .getNewsSource:
                return url.appendingPathComponent(NetworkConstants.sourcePath)
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
