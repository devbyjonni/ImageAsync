
import Foundation
import os.log

struct PhotoRepository: PhotoDataSource {
    private let apiService: PhotoAPIService
    
    init(apiService: PhotoAPIService) {
        self.apiService = apiService
    }
    
    func fetchData(for page: Int, pageLimit: Int, source: DataSource) async throws -> [PicsumPhoto] {
        switch source {
        case .local:
            LogMessages.repoAttemptingLocalDataFetch(functionName: #function)
            return []
        case .remote:
            return try await apiService.fetchData(for: page, pageLimit: pageLimit)
        case .bundle(let fileName):
            LogMessages.repoAttemptingBundleDataLoad(fileName: fileName, functionName: #function)
            let bundleManager = DefaultBundleManager()
            let photos: [PicsumPhoto] = try bundleManager.decode(from: fileName, as: [PicsumPhoto].self)
            LogMessages.repoBundleDataLoadSuccess(count: photos.count, fileName: fileName, functionName: #function)
            
            return photos
        }
    }
}

//MARK: Repository logging
extension LogMessages {
    static let repositoryLogger = Logger(subsystem: "com.photofetcher.data", category: "Repository")
    
    static func repoAttemptingLocalDataFetch(functionName: String = #function) {
        repositoryLogger.info("[\(functionName)] - Attempting to fetch local data.")
    }

    static func repoAttemptingBundleDataLoad(fileName: String, functionName: String = #function) {
        repositoryLogger.info("[\(functionName)] - Attempting to load data from bundle file: \(fileName).")
    }
    
    static func repoBundleDataLoadSuccess(count: Int, fileName: String, functionName: String = #function) {
        repositoryLogger.debug("[\(functionName)] - Loaded \(count) photos from the bundle file: \(fileName).")
    }
}


