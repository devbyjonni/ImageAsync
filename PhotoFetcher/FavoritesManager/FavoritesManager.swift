
import Foundation
import os.log

class FavoritesManager: ObservableObject {
    @Published var favorites: Set<String> = []
    
    private let defaults = UserDefaults.standard
    private let favoritesKey = "favoritePhotos"
    
    init() {
        loadFavorites()
    }
    
    func loadFavorites() {
        if let savedFavorites = defaults.object(forKey: favoritesKey) as? [String] {
            favorites = Set(savedFavorites)
            LogMessages.favoritesLoaded(count: favorites.count, functionName: #function)
        } else {
            LogMessages.favoritesLoadingError(functionName: #function)
        }
    }
    
    func saveFavorites() {
        defaults.set(Array(favorites), forKey: favoritesKey)
        LogMessages.favoritesSaved(count: favorites.count, functionName: #function)
    }
    
    func toggleFavorite(photoID: String) {
        if favorites.contains(photoID) {
            favorites.remove(photoID)
            LogMessages.favoriteRemoved(photoID: photoID, functionName: #function)
        } else {
            favorites.insert(photoID)
            LogMessages.favoriteAdded(photoID: photoID, functionName: #function)
        }
        saveFavorites()
    }
    
    func isFavorite(photoID: String) -> Bool {
        return favorites.contains(photoID)
    }
}

// MARK: - FavoritesManager Logging
extension LogMessages {
    static let favoritesLogger = Logger(subsystem: "com.photofetcher.favorites", category: "FavoritesManager")
    
    static func favoritesLoaded(count: Int, functionName: String = #function) {
        favoritesLogger.info("[\(functionName)] - Favorites loaded. Total count: \(count)")
    }
    
    static func favoritesLoadingError(functionName: String = #function) {
        favoritesLogger.error("[\(functionName)] - Failed to load favorites from UserDefaults.")
    }
    
    static func favoritesSaved(count: Int, functionName: String = #function) {
        favoritesLogger.info("[\(functionName)] - Favorites saved. Total count: \(count)")
    }
    
    static func favoriteAdded(photoID: String, functionName: String = #function) {
        favoritesLogger.info("[\(functionName)] - Added photo with ID \(photoID) to favorites.")
    }
    
    static func favoriteRemoved(photoID: String, functionName: String = #function) {
        favoritesLogger.info("[\(functionName)] - Removed photo with ID \(photoID) from favorites.")
    }
}


