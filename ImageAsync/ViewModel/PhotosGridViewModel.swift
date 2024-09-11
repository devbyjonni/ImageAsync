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
    
    private(set) var service: APIService
    private(set) var numberOfItemsPerPage = 30
    private(set) var currentPage = 1
    private(set) var lastItem = false
    
    init(service: PicsumPhotosService = PicsumPhotosService(
        networkManager: NetworkManager(),
        requestBuilder: PicsumPhotosRequestBuilder())
    ) {
        self.service = service
        loadData()
    }
    
    func loadData() {
        guard !isLoading && !lastItem else { return }
        
        isLoading = true
        viewModelError = nil
        
        Task {
            do {
                let fetchedPhotos = try await service.performFetch(for: currentPage, pageLimit: numberOfItemsPerPage, source: .api)
                processFetchedPhotos(fetchedPhotos)
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
