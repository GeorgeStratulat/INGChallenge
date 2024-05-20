//
//  NetworkRequest.swift
//  MarketingApp
//
//  Created by George Stratulat on 19.05.2024.
//

import Foundation
import Alamofire

public protocol NetworkRequest {
    var method: HTTPMethod { get }
    var path: String { get }
    var basePath: String { get throws }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var interceptor: RequestInterceptor? { get }
    var modifier: Session.RequestModifier? { get }
    var encoding: ParameterEncoding { get }
    associatedtype responseModel: Decodable
}

public extension NetworkRequest {
    var method: HTTPMethod {
        .get
    }
    
    var basePath: String {
        Constants.baseURL
    }
    
    var parameters: Parameters? { nil }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var interceptor: RequestInterceptor? {
        nil
    }
    
    var modifier: Session.RequestModifier? {
        nil
    }
    
    var encoding: ParameterEncoding {
        URLEncoding.default
    }
    
    var requestPath: URLConvertible {
        get throws {
            return URL(string: "\(try basePath)/\(path)") ?? ""
        }
    }
}
