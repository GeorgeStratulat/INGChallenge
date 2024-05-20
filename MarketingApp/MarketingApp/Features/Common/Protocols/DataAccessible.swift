//
//  DataAccessible.swift
//  MarketingApp
//
//  Created by George Stratulat on 19.05.2024.
//

import Combine

protocol DataAccessible {
    associatedtype ResultType
    var subject: CurrentValueSubject<Result<ResultType, Error>, Never> { get }
    var publisher: AnyPublisher<Result<ResultType, Error>, Never> { get }
    
    func fetch() async throws
}
