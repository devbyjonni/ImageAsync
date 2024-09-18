
import Foundation

enum RepositoryError: Error, Equatable {
    case localDataUnavailable
    case bundleDataUnavailable(String)
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .localDataUnavailable:
            return "Local data is unavailable."
        case .bundleDataUnavailable(let fileName):
            return "Failed to load data from bundle: \(fileName)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
