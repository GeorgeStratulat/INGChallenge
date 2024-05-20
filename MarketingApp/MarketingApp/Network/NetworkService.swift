//
//  NetworkService.swift
//  MarketingApp
//
//  Created by George Stratulat on 19.05.2024.
//

import Foundation

protocol NetworkService {
    /// Allows making a generic data request, using a `NetworkRequestable` type which contains information about request data and the desired output model
    func dataRequest<R: NetworkRequest>(for request: R) async throws -> R.responseModel
}
