//
//  NetworkErrors.swift
//  MarketingApp
//
//  Created by George Stratulat on 19.05.2024.
//

import Foundation

struct CommonErrorCodes {
    static let requestTimeout = NSURLErrorTimedOut
    static let hostNotFound = NSURLErrorCannotFindHost
    static let offline = NSURLErrorNotConnectedToInternet
    static let dataNotAllowed = NSURLErrorDataNotAllowed
}

enum NetworkError: Error {
    case custom(reason: String)
    case unacceptableCode(code: Int)
    case networkUnavailable
    case requestTimeout
    case hostNotFound
    case undefined
}

extension NetworkError: Equatable { }
