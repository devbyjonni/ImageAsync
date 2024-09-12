//
//  NetworkManager.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-11.
//

import Foundation

class NetworkManager: Network {
    private let session: URLSession

    // Add a default URLSession if none is passed (for production)
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: request)
        } catch {
            throw NetworkError.networkFailure("Failed to execute request.")
        }
    }
    
    func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(-1) // Throw an error for non-HTTP responses
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse(httpResponse.statusCode)
        }
    }
}
