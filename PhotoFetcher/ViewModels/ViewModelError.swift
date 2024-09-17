
import Foundation

enum ViewModelError: Identifiable {
    case networkError(String)
    case genericError(String)
    
    var id: String {
        switch self {
        case .networkError(let message), .genericError(let message):
            return message
        }
    }
    
    var title: String {
        switch self {
        case .networkError:
            return "Network Error"
        case .genericError:
            return "Oops! Something went wrong"
        }
    }
    
    var message: String {
        switch self {
        case .networkError(let message):
            return "It looks like there’s a network issue: \(message). Please check your internet connection and try again."
        case .genericError(let message):
            return "Something went wrong: \(message). Please try again later or contact support if the issue persists."
        }
    }
}

