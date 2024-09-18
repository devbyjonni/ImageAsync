import Foundation
import os.log

protocol PaginatedFetching {
    func fetch(for page: Int, pageLimit: Int, method: HTTPMethod) async throws -> [PicsumPhoto]
}

struct PaginatedFetcher: PaginatedFetching {
    private let requestBuilder: RequestBuilding
    private let networkManager: NetworkManaging
    
    init(requestBuilder: RequestBuilding, networkManager: NetworkManaging) {
        self.requestBuilder = requestBuilder
        self.networkManager = networkManager
    }
    
    func fetch(for page: Int, pageLimit: Int, method: HTTPMethod) async throws -> [PicsumPhoto] {
        do {
            LogMessages.fetchingPage(page: page, pageLimit: pageLimit, method: method.rawValue, functionName: #function)
            
            let request = try requestBuilder.buildRequest(for: page, pageLimit: pageLimit, method: method)
            LogMessages.requestBuiltSuccessfully(url: request.url?.absoluteString ?? "No URL", functionName: #function)
            
            let photos: [PicsumPhoto] = try await networkManager.executeRequest(request)
            LogMessages.fetchedPhotos(count: photos.count, page: page, functionName: #function)
            
            return photos
            
        } catch let error as RequestBuilderError {
            LogMessages.requestBuilderError(error: error.localizedDescription, functionName: #function)
            throw error
        } catch let error as NetworkError {
            LogMessages.networkManagerError(error: error.localizedDescription, functionName: #function)
            throw error
        } catch {
            LogMessages.unexpectedError(error: error.localizedDescription, functionName: #function)
            throw error
        }
    }
}

//MARK: PaginatedFetcher logging
extension LogMessages {
    static let paginatedFetcherLogger = Logger(subsystem: "com.photofetcher.network", category: "PaginatedFetcher")
    
    static func fetchingPage(page: Int, pageLimit: Int, method: String, functionName: String = #function) {
        paginatedFetcherLogger.info("[\(functionName)] - Fetching page \(page) with limit \(pageLimit) using method: \(method)")
    }
    
    static func requestBuiltSuccessfully(url: String, functionName: String = #function) {
        paginatedFetcherLogger.debug("[\(functionName)] - Request built successfully: \(url)")
    }
    
    static func fetchedPhotos(count: Int, page: Int, functionName: String = #function) {
        paginatedFetcherLogger.debug("[\(functionName)] - Successfully fetched \(count) photos for page \(page)")
    }
    
    static func requestBuilderError(error: String, functionName: String = #function) {
        paginatedFetcherLogger.error("[\(functionName)] - RequestBuilder error: \(error)")
    }
    
    static func networkManagerError(error: String, functionName: String = #function) {
        paginatedFetcherLogger.error("[\(functionName)] - NetworkManager error: \(error)")
    }
    
    static func unexpectedError(error: String, functionName: String = #function) {
        paginatedFetcherLogger.error("[\(functionName)] - Unexpected error: \(error)")
    }
}


