//
//  ErrorBoxView.swift
//  MarketingApp
//
//  Created by George Stratulat on 19.05.2024.
//

import SwiftUI

struct ErrorBoxView: View {
    let message: String
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(.red)
                .font(.largeTitle)
            
            Text("Error")
                .font(.headline)
                .foregroundColor(.red)
            
            Text(message)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    ErrorBoxView(message: "An error occurred while loading data. Please try again later.")
}
