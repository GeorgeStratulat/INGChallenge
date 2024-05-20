//
//  Review.swift
//  MarketingApp
//
//  Created by George Stratulat on 20.05.2024.
//

import SwiftUI

struct Review: View {
    @StateObject private var viewModel: ReviewViewModel
    
    init(providers: [Provider]) {
        self._viewModel = StateObject(wrappedValue: ReviewViewModel(providers: providers))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Review")
                .font(.title)
            Text("You are about to purchase:")
            VStack {
                ForEach(viewModel.providers, id: \.self) { provider in
                    VStack {
                        Text(provider.name)
                            .bold()
                        ForEach(provider.campaigns, id: \.self) { campaign in
                            VStack {
                                Text(campaign.price)
                                ForEach(campaign.options, id: \.self) { option in
                                    Text(option.name)
                                }
                            }
                        }
                        
                    }
                    .padding()
                    .background(Color.orange.opacity(0.25))
                    .cornerRadius(8)
                }
            }
            

            Spacer()
            Button {
                viewModel.sendEmail()
            } label: {
                Text("Send")
            }
        }
    }
}

#Preview {
    Review(providers: [Provider(id: 1, name: "Facebook", campaigns: [Campaign(id: 1, price: "Price 123", options: [CampaignOption(id: 1, name: "Option1")])])])
}
