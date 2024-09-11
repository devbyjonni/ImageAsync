//
//  ImagesGridViewModel.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-10.
//

import Foundation

// MARK: - ImagesGridViewModel
@MainActor
final class ImagesGridViewModel: ObservableObject {
    @Published var images: [ImageModel] = []
    @Published var isLoading = false
    @Published var viewModelError: ViewModelError?
    
    private(set) var service: APIService
    private(set) var numberOfImagesPerPage = 30
    private(set) var currentPage = 1
    private(set) var lastImages = false
    
    init(service: ImagesService = ImagesService(
        networkManager: NetworkManager(),
        requestBuilder: ImagesRequestBuilder())
    ) {
        self.service = service
        loadImages()
    }
    
    func loadImages() {
        guard !isLoading && !lastImages else { return }
        
        isLoading = true
        viewModelError = nil
        
        Task {
            do {
                let fetchedImages = try await service.performFetch(for: currentPage, pageLimit: numberOfImagesPerPage, source: .api)
                processFetchedImages(fetchedImages)
            } catch {
                handleFetchError(error)
            }
        }
    }
    
    private func processFetchedImages(_ newImages: [ImageModel]) {
        images.append(contentsOf: newImages)
        
        // Check if the fetched images are equal to the expected page size (e.g., 30)
        if newImages.count == numberOfImagesPerPage {
            currentPage += 1  // Increment page number after successful fetch
        } else {
            // If fewer images are returned, assume it's the last page
            lastImages = true
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
// MARK: - ViewModelError
enum ViewModelError: Identifiable {
    case networkError(String)
    case genericError(String)
    
    var id: String {
        switch self {
        case .networkError(let message), .genericError(let message):
            return message
        }
    }
    
    var errorMessage: String {
        switch self {
        case .networkError(let message):
            return "Network issue: \(message). Please check your connection."
        case .genericError(let message):
            return "Oops! Something went wrong: \(message)."
        }
    }
}
