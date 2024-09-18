
import Foundation

enum RequestBuilderError: Error, Equatable {
    case invalidURL(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL(let urlString):
            return "Invalid URL: \(urlString)"
        }
    }
}
