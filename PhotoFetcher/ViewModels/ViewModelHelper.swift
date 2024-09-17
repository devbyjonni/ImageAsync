import Foundation

struct ViewModelHelper {
    
    // Handles network-specific errors and maps them to ViewModelError
    static func handleNetworkError(error: NetworkError) -> ViewModelError {
        switch error {
        case .noInternetConnection:
            LogMessages.viewModelNoInternetConnection(functionName: #function)
            return .networkError("You are not connected to the internet. Please check your connection.")
        case .requestTimeout:
            LogMessages.viewModelRequestTimeout(functionName: #function)
            return .networkError("The request timed out. Please try again.")
        case .serverError(let message):
            LogMessages.viewModelServerError(message: message, functionName: #function)
            return .networkError("Server error: \(message). Please try again later.")
        default:
            LogMessages.viewModelGeneralNetworkError(functionName: #function)
            return .networkError("A network error occurred. Please try again.")
        }
    }
    
    // Handles repository-specific errors and maps them to ViewModelError
    static func handleError(_ error: RepositoryError) -> ViewModelError {
        switch error {
        case .localDataUnavailable:
            LogMessages.viewModelLocalDataUnavailable(functionName: #function)
            return .genericError("Local data is not available.")
        case .bundleDataUnavailable(let fileName):
            LogMessages.viewModelBundleDataUnavailable(fileName: fileName, functionName: #function)
            return .genericError("Failed to load data from bundle: \(fileName).")
        case .unknown:
            LogMessages.viewModelUnknownRepositoryError(functionName: #function)
            return .genericError("An unknown error occurred.")
        }
    }
    
    // Handles ViewModelError itself and possibly transforms or updates the error
    static func handleViewModelError(_ error: ViewModelError) -> ViewModelError {
        switch error {
        case .genericError:
            return .genericError("Failed to load data.")
        case .networkError:
            return .networkError("A network issue occurred. Please try again.")
        }
    }
}


