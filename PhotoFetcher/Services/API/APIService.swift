import Foundation
import os.log

protocol APIService {
    func fetchData(for page: Int, pageLimit: Int, method: HTTPMethod) async throws -> [PicsumPhoto]
}

struct PhotoAPIService: APIService {
    private let fetcher: PaginatedFetching
    private let requestBuilder: RequestBuilding
    private let networkManager: NetworkManaging
    
    init(fetcher: PaginatedFetching, requestBuilder: RequestBuilding, networkManager: NetworkManaging) {
        self.fetcher = fetcher
        self.requestBuilder = requestBuilder
        self.networkManager = networkManager
    }
    
    func fetchData(for page: Int, pageLimit: Int, method: HTTPMethod = .GET) async throws -> [PicsumPhoto] {
        do {
            LogMessages.apiFetchingData(page: page, pageLimit: pageLimit, method: method.rawValue, functionName: #function)
            let data = try await fetcher.fetch(for: page, pageLimit: pageLimit, method: method)
            LogMessages.apiFetchedDataSuccess(page: page, functionName: #function)
            return data
        } catch let error as RequestBuilderError {
            LogMessages.apiRequestBuilderError(error: error.localizedDescription, functionName: #function)
            throw error
        } catch let error as NetworkError {
            LogMessages.apiNetworkManagerError(error: error.localizedDescription, functionName: #function)
            throw error
        } catch {
            LogMessages.apiUnexpectedError(error: error.localizedDescription, functionName: #function)
            throw error
        }
    }
}

//MARK: APIService logging
extension LogMessages {
    static let apiServiceLogger = Logger(subsystem: "com.yourapp.network", category: "APIService")
    
    static func apiFetchingData(page: Int, pageLimit: Int, method: String, functionName: String = #function) {
        apiServiceLogger.info("[\(functionName)] - Fetching data for page \(page), pageLimit \(pageLimit), method: \(method)")
    }
    
    static func apiFetchedDataSuccess(page: Int, functionName: String = #function) {
        apiServiceLogger.debug("[\(functionName)] - Successfully fetched data for page \(page)")
    }
    
    static func apiRequestBuilderError(error: String, functionName: String = #function) {
        apiServiceLogger.error("[\(functionName)] - RequestBuilder error: \(error)")
    }
    
    static func apiNetworkManagerError(error: String, functionName: String = #function) {
        apiServiceLogger.error("[\(functionName)] - NetworkManager error: \(error)")
    }
    
    static func apiUnexpectedError(error: String, functionName: String = #function) {
        apiServiceLogger.error("[\(functionName)] - Unexpected error: \(error)")
    }
}


