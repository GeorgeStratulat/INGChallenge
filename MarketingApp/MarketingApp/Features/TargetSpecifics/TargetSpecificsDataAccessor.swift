//
//  TargetSpecificsDataAccessor.swift
//  MarketingApp
//
//  Created by George Stratulat on 19.05.2024.
//

import Foundation
import Combine

final class TargetSpecificsDataAccessor: DataAccessible {
    let subject: CurrentValueSubject<Result<[TargetingSpecifics], Error>, Never> = CurrentValueSubject(.success([]))
    var publisher: AnyPublisher<Result<[TargetingSpecifics], Error>, Never> {
        subject.eraseToAnyPublisher()
    }
    private let networkClient: NetworkService
    
    init(networkClient: NetworkService = NetworkImplementation()) {
        self.networkClient = networkClient
    }
    
    func fetch() async throws {
        let targetSpecificsRequest = TargetSpecificsRequest()
        do {
            let targetSpecificsResponse = try await networkClient.dataRequest(for: targetSpecificsRequest)
            subject.send(.success(targetSpecificsResponse.record))
        } catch {
            subject.send(.failure(error))
        }
    }
}
