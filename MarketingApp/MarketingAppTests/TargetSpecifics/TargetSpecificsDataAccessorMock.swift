//
//  TargetSpecificsDataAccessorMock.swift
//  MarketingAppTests
//
//  Created by George Stratulat on 20.05.2024.
//

import Foundation
import Combine

final class TargetSpecificsDataAccessorMock: DataAccessible {
    let subject: CurrentValueSubject<Result<[TargetingSpecifics], Error>, Never>
    var publisher: AnyPublisher<Result<[TargetingSpecifics], Error>, Never> {
        subject.eraseToAnyPublisher()
    }
    
    init(targetingSpecifics: [TargetingSpecifics] = [], shouldError: Bool = false) {
        self.subject = CurrentValueSubject(.success(targetingSpecifics))
        self.shouldError = shouldError
    }
    
    let shouldError: Bool
    
    private let targetingSpecifics = [
        TargetingSpecifics(id: 1, name: "Location", providers: [ProviderPreview(id: 1, name: "Facebook"), ProviderPreview(id: 2, name: "Twitter")]),
        TargetingSpecifics(id: 1, name: "Sex", providers: [ProviderPreview(id: 1, name: "Facebook"), ProviderPreview(id: 2, name: "Instagram")])
    ]
    
    func fetch() async throws {
        if shouldError {
            subject.send(.failure(NSError(domain: "error domain", code: 21)))
        } else {
            subject.send(.success(targetingSpecifics))
        }
    }
    
}
