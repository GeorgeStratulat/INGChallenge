//
//  CampaignView.swift
//  MarketingApp
//
//  Created by George Stratulat on 19.05.2024.
//

import SwiftUI

struct CampaignView: View {
    let campaign: Campaign
    
    var body: some View {
        VStack {
            Text(campaign.price)
                .font(.title)
                .padding()
            ForEach(campaign.options, id: \.self) { option in
                Text(option.name)
            }
        }
        .padding()
        .background(Color.orange.opacity(0.8))
        .cornerRadius(8)
    }
}

#Preview {
    CampaignView(campaign: Campaign(id: 1, price: "123 Euro", options: [CampaignOption(id: 1, name: "Option 1")]))
}
