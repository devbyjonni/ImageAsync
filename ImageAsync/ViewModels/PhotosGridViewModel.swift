//
//  PhotosGridViewModel.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-10.
//

import Foundation

@MainActor
final class PhotosGridViewModel: ObservableObject {
    @Published var picsumPhotos: [PicsumPhoto] = []
    @Published var isLoading = false
    @Published var viewModelError: ViewModelError?
    
    private let photoRepository: PhotoRepository
    private(set) var numberOfItemsPerPage = 30
    private(set) var currentPage = 1
    private(set) var lastItem = false
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
        loadData()
    }
    
    func loadData() {
        guard !isLoading && !lastItem else { return }
        
        isLoading = true
        viewModelError = nil
        
        Task {
            do {
                let photos = try await photoRepository.fetchPhotos(page: currentPage, pageLimit: 30)
                processFetchedPhotos(photos)
            } catch {
                handleFetchError(error)
            }
        }
    }
    
    private func processFetchedPhotos(_ newPhotos: [PicsumPhoto]) {
        picsumPhotos.append(contentsOf: newPhotos)
        
        // Check if the fetched photos are equal to the expected page size (e.g., 30)
        if newPhotos.count == numberOfItemsPerPage {
            currentPage += 1  // Increment page number after successful fetch
        } else {
            lastItem = true
        }
        
        isLoading = false  // Reset the loading state
    }
    
    private func handleFetchError(_ error: Error) {
        isLoading = false
        switch error {
        case let networkError as NetworkError:
            viewModelError = .networkError(networkError.localizedDescription)
        case let serviceError as ServiceError:
            viewModelError = .genericError(serviceError.localizedDescription)
        default:
            viewModelError = .genericError("An unknown error occurred.")
        }
    }
}
