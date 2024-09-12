//
//  BaseAPIService.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-12.
//

import Foundation

class BaseAPIService<T: Decodable>: APIService {
    let networkManager: Network
    let requestBuilder: APIRequestBuilder
    typealias Model = T
    
    init(networkManager: Network, requestBuilder: APIRequestBuilder) {
        self.networkManager = networkManager
        self.requestBuilder = requestBuilder
    }
    
    func performRequest(for page: Int, pageLimit: Int, method: HTTPMethod) async throws -> T {
        guard let request = requestBuilder.buildRequest(for: page, pageLimit: pageLimit, method: method) else {
            throw ServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await networkManager.performRequest(request)
            try networkManager.validateResponse(response)
            return try decode(data)
        } catch let error as NetworkError {
            throw ServiceError.networkError(error)
        } catch {
            throw ServiceError.unknownError(error.localizedDescription)
        }
    }
    
    func decode(_ data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ServiceError.decodingError("Failed to decode data")
        }
    }
}
