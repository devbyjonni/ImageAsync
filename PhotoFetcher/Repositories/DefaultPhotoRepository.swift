//
//  DefaultPhotoRepository.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-12.
//

import Foundation

class DefaultPhotoRepository: PhotoRepository {
    private let apiService: PicsumPhotosService  // Make sure it's specific to PicsumPhotosService
    private let persistenceService: PersistenceService

    init(apiService: PicsumPhotosService, persistenceService: PersistenceService) {
        self.apiService = apiService
        self.persistenceService = persistenceService
    }

    func fetchPhotos(page: Int, pageLimit: Int) async throws -> [PicsumPhoto] {
        // Try to load from local storage first
        do {
            let storedPhotos = try persistenceService.fetchPhotos()
            if !storedPhotos.isEmpty {
                return storedPhotos
            }
        } catch {
            print("Failed to load stored photos: \(error)")
        }

        // Fallback to API if no local data
        let fetchedPhotos = try await apiService.fetchPicsumPhotos(page: page, pageLimit: pageLimit)
        try persistenceService.savePhotos(fetchedPhotos)
        return fetchedPhotos
    }
}
