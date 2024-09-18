
import Foundation

class BaseViewModel: ViewModel {
    @Published var photos: [PicsumPhoto] = []
    @Published var viewModelError: ViewModelError?
    @Published var isShowingFavorites = false
    
    private let repository: PhotoDataSource
    private let favoritesManager = FavoritesManager()
    private let numberOfItemsPerPage = 30
    private var currentPage = 1
    private var isLastPhoto = false
    private var isLoading = false
    
    required init(dependency: DependencyContainer) {
        self.repository = dependency.repository
        loadData()
    }
    
    func loadData() {
        guard !isLoading && !isLastPhoto else {
            LogMessages.viewModelLoadingSkipped(reason: "Currently loading or at the last photo, or in favorites mode", functionName: #function)
            return
        }
        
        isLoading = true
        viewModelError = nil
        LogMessages.viewModelLoadingDataStarted(page: currentPage, pageLimit: numberOfItemsPerPage, functionName: #function)
        
        Task {
            do {
                let newPhotos = try await repository.fetchData(for: currentPage, pageLimit: numberOfItemsPerPage, source: .remote)
                LogMessages.viewModelFetchFromRemoteSuccess(count: newPhotos.count, page: currentPage, functionName: #function)
                
                processPhotos(newPhotos)
                
                // Add the viewModelFetchSuccess log here after processing photos
                LogMessages.viewModelFetchSuccess(count: newPhotos.count, page: currentPage, pageLimit: numberOfItemsPerPage, functionName: #function)
            } catch let error as NetworkError {
                LogMessages.viewModelDataLoadError(error: error.localizedDescription, functionName: #function)
                viewModelError = ViewModelHelper.handleNetworkError(error: error)
            } catch let error as RepositoryError {
                LogMessages.viewModelDataLoadError(error: error.localizedDescription, functionName: #function)
                viewModelError = ViewModelHelper.handleError(error)
            } catch {
                LogMessages.viewModelDataLoadError(error: error.localizedDescription, functionName: #function)
                viewModelError = ViewModelHelper.handleViewModelError(.genericError("Failed to load data.")) // Handles generic ViewModelError
            }
            isLoading = false
        }
    }

    private func processPhotos(_ newPhotos: [PicsumPhoto]) {
        photos.append(contentsOf: newPhotos)
        LogMessages.viewModelLoadingDataFinished(page: currentPage, functionName: #function)
        currentPage += 1
        
        if newPhotos.count < numberOfItemsPerPage {
            isLastPhoto = true
        }
    }
    
    // Function to check if a photo is a favorite
    func isFavorite(photo: PicsumPhoto) -> Bool {
        return favoritesManager.isFavorite(photoID: photo.id)
    }
    
    // Function to toggle a photo's favorite status
    func toggleFavorite(photo: PicsumPhoto) {
        favoritesManager.toggleFavorite(photoID: photo.id)
        
        if isShowingFavorites {
            photos.removeAll { $0.id == photo.id }
        }
    }
    
    func toggleFavorites() {
        isShowingFavorites.toggle()
        if isShowingFavorites {
            photos = photos.filter { favoritesManager.isFavorite(photoID: $0.id) }
        } else {
            photos = []
            currentPage = 1
            isLastPhoto = false
            loadData()
        }
    }
}

//MARK: ViewModel logging
import os.log
extension LogMessages {
    static let viewModelLogger = Logger(subsystem: "com.photofetcher.ui", category: "ViewModel")
    
    // MARK: - View Model
    static func viewModelFetchSuccess(count: Int, page: Int, pageLimit: Int, functionName: String = #function) {
        viewModelLogger.info("""
        [\(functionName)] - 🚀 Successfully loaded \(count) photos. Page: \(page), Page Limit: \(pageLimit).
        """)
    }
    
    static func viewModelLoadingSkipped(reason: String, functionName: String = #function) {
        viewModelLogger.info("[\(functionName)] - Loading skipped: \(reason).")
    }
    
    static func viewModelLoadingDataStarted(page: Int, pageLimit: Int, functionName: String = #function) {
        viewModelLogger.info("[\(functionName)] - Started loading data for page \(page) with page limit \(pageLimit).")
    }
    
    static func viewModelFetchFromRemoteSuccess(count: Int, page: Int, functionName: String = #function) {
        viewModelLogger.info("[\(functionName)] - Successfully fetched \(count) photos from remote for page \(page).")
    }
    
    static func viewModelDataLoadError(error: String, functionName: String = #function) {
        viewModelLogger.error("[\(functionName)] - Failed to load data: \(error).")
    }
    
    static func viewModelLoadingDataFinished(page: Int, functionName: String = #function) {
        viewModelLogger.info("[\(functionName)] - Finished loading data for page \(page).")
    }
    
    static func viewModelLocalDataUnavailable(functionName: String = #function) {
        viewModelLogger.error("[\(functionName)] - Local data is unavailable.")
    }
    
    static func viewModelBundleDataUnavailable(fileName: String, functionName: String = #function) {
        viewModelLogger.error("[\(functionName)] - Failed to load data from bundle: \(fileName).")
    }
    
    static func viewModelUnknownRepositoryError(functionName: String = #function) {
        viewModelLogger.error("[\(functionName)] - An unknown repository error occurred.")
    }
    
    static func viewModelNoInternetConnection(functionName: String = #function) {
        viewModelLogger.error("[\(functionName)] - No internet connection.")
    }
    
    static func viewModelRequestTimeout(functionName: String = #function) {
        viewModelLogger.error("[\(functionName)] - Request timed out.")
    }
    
    static func viewModelServerError(message: String, functionName: String = #function) {
        viewModelLogger.error("[\(functionName)] - Server error: \(message).")
    }
    
    static func viewModelGeneralNetworkError(functionName: String = #function) {
        viewModelLogger.error("[\(functionName)] - A general network error occurred.")
    }
    
    static func viewModelInit(name: String, functionName: String = #function) {
        viewModelLogger.info("[\(functionName)] - \(name) has been initialized.")
    }
}


