
import Foundation
import os.log

struct DependencyContainer {
    private(set) var repository: PhotoRepository

    init() {
        LogMessages.dependencyContainerInit(functionName: #function)
        let sessionBuilder = SessionBuilder()
        let session = sessionBuilder.buildForegroundSession()
        let networkManager = NetworkManager(session: session)
        let requestBuilder = RequestBuilder()
        let paginatedFetcher = PaginatedFetcher(requestBuilder: requestBuilder, networkManager: networkManager)
        let apiService = PhotoAPIService(fetcher: paginatedFetcher)
        
        self.repository = PhotoRepository(apiService: apiService)
    }
}

// MARK: - DependencyContainer Logging
extension LogMessages {
    static let dependencyLogger = Logger(subsystem: "com.photofetcher.dependency", category: "DependencyContainer")
    
    static func dependencyContainerInit(functionName: String = #function) {
        dependencyLogger.info("[\(functionName)] - DependencyContainer has been initialized.")
    }
}
