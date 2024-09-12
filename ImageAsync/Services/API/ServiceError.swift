//
//  ServiceError.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-12.
//

import Foundation

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
