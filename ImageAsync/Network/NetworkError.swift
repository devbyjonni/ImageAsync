//
//  NetworkError.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-12.
//

import Foundation

enum NetworkError: Error, Equatable {
    case networkFailure(String)
    case invalidResponse(Int)
    
    var localizedDescription: String {
        switch self {
        case .networkFailure(let message):
            return "Network failure: \(message)"
        case .invalidResponse(let statusCode):
            return "Invalid response with status code: \(statusCode)"
        }
    }
}
