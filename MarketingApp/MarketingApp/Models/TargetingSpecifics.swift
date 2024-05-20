//
//  TargetingSpecifics.swift
//  MarketingApp
//
//  Created by George Stratulat on 19.05.2024.
//

import Foundation

struct TargetingSpecifics: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let providers: [ProviderPreview]
}

struct ProviderPreview: Codable, Hashable {
    let id: Int
    let name: String
}
