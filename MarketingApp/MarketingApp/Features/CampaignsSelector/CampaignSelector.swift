//
//  CampaignSelector.swift
//  MarketingApp
//
//  Created by George Stratulat on 19.05.2024.
//

import SwiftUI

struct CampaignSelector: View {
    @Binding var selectedCampaigns: [Int]
    @Binding var selectedProvider: Provider?
    @State private var selected: Int? = nil
    
    var body: some View {
        if let campaigns = selectedProvider?.campaigns {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        selectedProvider = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .padding()
                    }

                }
                Spacer()
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(campaigns, id:\.self) { campaign in
                            VStack {
                                CampaignView(campaign: campaign)
                                
                                Button {
                                    if selected == campaign.id {
                                        selectedCampaigns.removeAll { $0 == campaign.id }
                                        selected = nil
                                    } else {
                                        if let currentSelectedCampaign = selected {
                                            selectedCampaigns.removeAll { $0 == currentSelectedCampaign }
                                        }
                                        selectedCampaigns.append(campaign.id)
                                        selected = campaign.id
                                    }
                                } label: {
                                    selectedCampaigns.contains(campaign.id) ? Image(systemName: "checkmark.square"): Image(systemName: "square")
                                }
                                .padding()
                                
                            }
                            
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .safeAreaPadding(.horizontal, 40)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green.opacity(0.15))
        }
    }
    
}

#Preview {
    CampaignSelector(selectedCampaigns: .constant([1]), selectedProvider: .constant(Provider(id: 1, name: "Facebook", campaigns: [Campaign(id: 1, price: "123 Euro", options: [CampaignOption(id: 1, name: "Option 1")]),
                                                                                                                                  Campaign(id: 2, price: "125 Euro", options: [CampaignOption(id: 1, name: "Option 1"), CampaignOption(id: 2, name: "Option 2")])])))
}
