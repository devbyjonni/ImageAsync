
import Foundation

enum NetworkError: Error, Equatable {
    case networkFailure(String)
    case invalidResponse(Int)
    case decodingError(String)
    case requestTimeout
    case noInternetConnection
    case serverError(String) // E.g., 500 series errors
    
    var localizedDescription: String {
        switch self {
        case .networkFailure(let message):
            return "Network failure: \(message)"
        case .invalidResponse(let statusCode):
            return "Invalid response with status code: \(statusCode)"
        case .decodingError(let message):
            return "Decoding Error: \(message)"
        case .requestTimeout:
            return "The request timed out."
        case .noInternetConnection:
            return "No internet connection."
        case .serverError(let message):
            return "Server error: \(message)"
        }
    }
}
