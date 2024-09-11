//
//  BaseAPIService.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-11.
//

import Foundation

// MARK: - APIService Protocol
protocol APIService {
    func performFetch(for page: Int, pageLimit: Int, source: DataSource) async throws -> [PicsumPhoto]
}
// MARK: - BaseAPIService
class BaseAPIService<T: Decodable> {
    let networkManager: Network
    let requestBuilder: APIRequestBuilder
    let bundleManager: BundleManager? // Optional BundleManager for JSON loading
    
    init(networkManager: Network, requestBuilder: APIRequestBuilder, bundleManager: BundleManager? = nil) {
        self.networkManager = networkManager
        self.requestBuilder = requestBuilder
        self.bundleManager = bundleManager
    }
    
    func performRequest(for page: Int, pageLimit: Int, method: HTTPMethod, fromBundle fileName: String? = nil) async throws -> T {
        
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
// MARK: - ServiceError
enum ServiceError: Error {
    case networkError(NetworkError)  // Wrap NetworkError for clarity
    case decodingError(String)
    case unknownError(String)
    case invalidURL
    
    var localizedDescription: String {
        switch self {
        case .networkError(let networkingError):
            return networkingError.localizedDescription
        case .decodingError(let message):
            return "Decoding Error: \(message)"
        case .unknownError(let message):
            return "Unknown Error: \(message)"
        case .invalidURL:
            return "The URL provided is invalid."
        }
    }
}
