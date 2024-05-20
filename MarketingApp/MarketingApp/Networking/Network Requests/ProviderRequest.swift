//
//  ProviderRequest.swift
//  MarketingApp
//
//  Created by George Stratulat on 19.05.2024.
//

import Alamofire

struct ProviderRequest: NetworkRequest {
    typealias responseModel = ProviderResponse
    
    var path: String {
        "b/664b03d8e41b4d34e4f68b2f"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: HTTPHeaders? {
       return [
           "X-Master-Key": Constants.apiKey,
           "X-Access-Key": Constants.accessKey
       ]
   }
}

struct ProviderResponse: Codable {
    let record: [Provider]
}
