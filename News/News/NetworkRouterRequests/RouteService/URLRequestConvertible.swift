//
//  URLRequestConvertable.swift
//  News
//
//  Created by Abhishek Kumar on 24/02/22.
//

import Foundation

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}
