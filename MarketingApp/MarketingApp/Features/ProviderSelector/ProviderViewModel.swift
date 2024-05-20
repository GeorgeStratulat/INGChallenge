//
//  ProviderViewModel.swift
//  MarketingApp
//
//  Created by George Stratulat on 20.05.2024.
//

import Foundation
import Combine

final class ProviderViewModel<DataAccessor: ProviderDataAccessible>: ObservableObject {
    private var providersDA: DataAccessor
    
    var task: Task<Void, Error>? = nil
    var cancellables: Set<AnyCancellable> = []
    @Published var selectedProvider: Provider? = nil // used for opening campaign selector
    @Published var selectedCampaigns = [Int]()
    @Published var providers = [Provider]()
    @Published var loading = false
    @Published var error: String? = nil
    
    init(providersDA: DataAccessor = ProviderDataAccessor()) {
        self.providersDA = providersDA
        
        providersDA.publisher
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] result in
                guard let self = self else {
                    return
                }
                self.loading = false
                switch result {
                case .success(let providers):
                    if let specificData = providers as? [Provider] {
                        self.providers = specificData
                    }
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }
            .store(in: &self.cancellables)
    }
    
    func loadData(for ids: [Int]) {
        self.task?.cancel()
        self.task = Task { [weak self] in
            guard let self = self else {
                return
            }
            
            try await providersDA.fetch(for: ids)
        }
    }
    
    var resultedProviders: [Provider] {
        var resultedProviders: [Provider] = []
        for provider in providers {
            var campaigns: [Campaign] = []
            let providerCampaigns = provider.campaigns.filter({ selectedCampaigns.contains($0.id)})
            campaigns.append(contentsOf: providerCampaigns)
            if campaigns.isEmpty {
                break
            }
            resultedProviders.append(Provider(id: provider.id, name: provider.name, campaigns: campaigns))
        }
        return resultedProviders
    }
    
    
}
