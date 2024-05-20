//
//  Provider.swift
//  MarketingApp
//
//  Created by George Stratulat on 19.05.2024.
//

import Foundation

struct Provider: Codable, Hashable {
    let id: Int
    let name: String

    let campaigns: [Campaign]
}

struct Campaign: Codable, Hashable {
    let id: Int
    let price: String
    let options: [CampaignOption]
}

struct CampaignOption: Codable, Hashable {
    let id: Int
    let name: String
}
