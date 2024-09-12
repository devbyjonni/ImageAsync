//
//  DefaultPhotoRepository.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-12.
//

import Foundation

class DefaultPhotoRepository: PhotoRepository {
    private let apiService: APIService
    private let persistenceService: PersistenceService

    init(apiService: APIService, persistenceService: PersistenceService) {
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
        let fetchedPhotos = try await apiService.performFetch(for: page, pageLimit: pageLimit, source: .api)
        try persistenceService.savePhotos(fetchedPhotos)
        return fetchedPhotos
    }
}
