//
//  ProviderDataAccessor.swift
//  MarketingApp
//
//  Created by George Stratulat on 20.05.2024.
//

import Foundation
import Combine

final class ProviderDataAccessor: ProviderDataAccessible {
    let subject: CurrentValueSubject<Result<[Provider], Error>, Never> = CurrentValueSubject(.success([]))
    var publisher: AnyPublisher<Result<[Provider], Error>, Never> {
        subject.eraseToAnyPublisher()
    }
    private let networkClient: NetworkService
    
    init(networkClient: NetworkService = NetworkImplementation()) {
        self.networkClient = networkClient
    }
    
    func fetch() async throws {}
    
    func fetch(for ids: [Int]) async throws {
        let providersRequest = ProviderRequest()
        do {
            let providersResponse = try await networkClient.dataRequest(for: providersRequest)
            var providers = providersResponse.record
            providers = providers.filter({ ids.contains($0.id) })
            subject.send(.success(providers))
        } catch {
            subject.send(.failure(error))
        }
    }
    
}
