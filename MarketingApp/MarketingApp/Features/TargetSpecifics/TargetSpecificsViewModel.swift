//
//  TargetSpecificsViewModel.swift
//  MarketingApp
//
//  Created by George Stratulat on 19.05.2024.
//

import Foundation
import Combine

final class TargetSpecificsViewModel<DataAccessor: DataAccessible>: ObservableObject {
    private var targetSpecificDA: DataAccessor
    
    var task: Task<Void, Error>? = nil
    var cancellables: Set<AnyCancellable> = []
    @Published var targetSpecifics = [TargetingSpecifics]()
    @Published var selectedTargets: Set<Int> = []
    @Published var loading = false
    @Published var error: String? = nil
    
    
    init(targetSpecificDA: DataAccessor) {
        self.targetSpecificDA = targetSpecificDA
        
        targetSpecificDA.publisher
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] result in
                guard let self = self else {
                    return
                }
                self.loading = false
                switch result {
                case .success(let targetSpecifics):
                    if let specificData = targetSpecifics as? [TargetingSpecifics] {
                        self.targetSpecifics = specificData
                    }
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }
            .store(in: &self.cancellables)
    }
    
    func loadData() {
        self.task?.cancel()
        self.task = Task { [weak self] in
            guard let self = self else {
                return
            }
            
            try await targetSpecificDA.fetch()
        }
    }
    
    func selectTarget(id: Int) {
        if selectedTargets.contains(id) {
            selectedTargets.remove(id)
        } else {
            selectedTargets.insert(id)
        }
    }
    
    func providersForTargetSpecifics() -> [ProviderPreview] {
        let allProviders = targetSpecifics
            .filter { selectedTargets.contains($0.id) }
            .flatMap { $0.providers }

        let providerCounts = allProviders.reduce(into: [:]) { counts, provider in
            counts[provider, default: 0] += 1
        }

        let commonProviders = providerCounts.filter { $0.value == selectedTargets.count }
        
        return commonProviders.map { $0.key }
    }
}
