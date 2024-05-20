//
//  NetworkImplementation.swift
//  MarketingApp
//
//  Created by George Stratulat on 19.05.2024.
//

import Foundation
import Alamofire

final class NetworkImplementation: NetworkService {
    func dataRequest<R>(for req: R) async throws -> R.responseModel where R : NetworkRequest {
        let serializer = Serializer<R.responseModel>()
        let dataTask = AF.request(try req.requestPath,
                                  method: req.method,
                                  parameters: req.parameters,
                                  encoding: req.encoding,
                                  headers: req.headers,
                                  interceptor: req.interceptor,
                                  requestModifier: req.modifier)
            .serializingResponse(using: serializer)
        
        let response = await dataTask.response
            .mapError { afError -> NetworkError in
                if let error = afError.underlyingError as? NetworkError {
                    return error
                } else if let error = afError.underlyingError as? NSError, error.code == CommonErrorCodes.requestTimeout {
                    return NetworkError.requestTimeout
                } else if let error = afError.underlyingError as? NSError, error.code == CommonErrorCodes.hostNotFound {
                    return NetworkError.hostNotFound
                } else if let error = afError.underlyingError as? NSError, error.code == CommonErrorCodes.offline {
                    return NetworkError.networkUnavailable
                } else if let error = afError.underlyingError as? NSError, error.code == CommonErrorCodes.dataNotAllowed {
                    return NetworkError.networkUnavailable
                }
                
                return NetworkError.custom(reason: afError.localizedDescription)
            }
        
        switch response.result {
        case .success(let decodedModel):
            return decodedModel
        case .failure(let error):
            throw error
        }
    }
}
