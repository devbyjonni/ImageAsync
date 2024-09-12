//
//  PhotoService.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-11.
//

import Foundation

class PhotoService: APIService {
    let networkManager: Network
    let requestBuilder: APIRequestBuilder
    let bundleManager: BundleManager? // Optional BundleManager for JSON loading

    init(networkManager: Network, requestBuilder: APIRequestBuilder, bundleManager: BundleManager? = nil) {
        self.networkManager = networkManager
        self.requestBuilder = requestBuilder
        self.bundleManager = bundleManager
    }

    // Perform fetching for API or bundle
    func performFetch(for page: Int, pageLimit: Int, source: DataSource) async throws -> [PicsumPhoto] {
        switch source {
        case .api:
            return try await performRequest(for: page, pageLimit: pageLimit, method: .GET)
        case .bundle(let name):
            return try loadFromBundle(bundleName: name)
        }
    }

    // Private method to handle API requests
    private func performRequest(for page: Int, pageLimit: Int, method: HTTPMethod) async throws -> [PicsumPhoto] {
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

    // Private method to handle bundle loading
    private func loadFromBundle(bundleName: String) throws -> [PicsumPhoto] {
        let bundleManager = self.bundleManager ?? DefaultBundleManager()
        let data = try bundleManager.loadJSONData(from: bundleName)
        return try decode(data)
    }

    // Decoding logic
    private func decode(_ data: Data) throws -> [PicsumPhoto] {
        do {
            return try JSONDecoder().decode([PicsumPhoto].self, from: data)
        } catch {
            throw ServiceError.decodingError("Failed to decode data")
        }
    }
}
