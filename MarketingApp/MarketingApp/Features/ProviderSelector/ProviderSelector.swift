//
//  ProviderSelector.swift
//  MarketingApp
//
//  Created by George Stratulat on 19.05.2024.
//

import SwiftUI

struct ProviderSelector: View {
    @StateObject private var viewModel = ProviderViewModel()
    let givenProviders: [Int]
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            VStack {
                if viewModel.loading {
                    ProgressView()
                } else {
                    if let error = viewModel.error {
                        ErrorBoxView(message: error)
                    }
                    if viewModel.providers.count > 0 {
                        Text("Based on your targeting specifics, we have this platforms available for you:")
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.providers, id: \.self) { provider in
                                    VStack {
                                        Text(provider.name)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.gray.opacity(0.5))
                                            .cornerRadius(8)
                                            .onTapGesture {
                                                viewModel.selectedProvider = provider
                                            }
                                        if let selectedCampaign = selectedCampaign(for: provider) {
                                            Text("Selected:")
                                            Text(selectedCampaign.price)
                                        }
                                    }
                                    
                                }
                            }
                            .padding()
                        }
                        
                        if viewModel.selectedCampaigns.count > 0 {
                            NavigationLink {
                                Review(providers: viewModel.resultedProviders)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                Text("Next")
                                    .foregroundColor(.blue)
                            }

                        }
                    }
                }
            }
            
        }
        .onAppear {
            viewModel.loadData(for: givenProviders)
        }
        .fullScreenCover(isPresented: Binding<Bool>(
                    get: { viewModel.selectedProvider != nil },
                    set: { _ in }
                )) {
                    CampaignSelector(selectedCampaigns: $viewModel.selectedCampaigns, selectedProvider: $viewModel.selectedProvider)
                }
        
    }
    
    private func selectedCampaign(for provider: Provider) -> Campaign? {
        for campaign in provider.campaigns {
            if viewModel.selectedCampaigns.contains(campaign.id) {
                return campaign
            }
        }
        return nil
    }
    
}

//#Preview {
//    ProviderSelector(channels: [ProviderPreview(id: 1, name: "Facebook")])
//}
