//
//  ProviderDataAccessible.swift
//  MarketingApp
//
//  Created by George Stratulat on 20.05.2024.
//

import Foundation

protocol ProviderDataAccessible: DataAccessible {
    func fetch(for ids: [Int]) async throws
}
