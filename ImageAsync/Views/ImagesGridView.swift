//
//  ImagesGridView.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-09.
//
// I think your current approach strikes a great balance between simplicity and flexibility, making it both easy to test and to extend in the future!

import Foundation
import SwiftUI

// MARK: - ImagesGridView
struct ImagesGridView: View {
    @StateObject var vm = ImagesGridViewModel()
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3), spacing: 10) {
                ForEach(vm.images) { image in
                    ImageCardView(imageModel: image)
                        .onAppear {
                            // When the last image appears, trigger pagination
                            if image.id == vm.images.last?.id {
                                vm.loadImages()
                            }
                        }
                }
            }
            .overlay(alignment: .bottom, content: {
                if vm.isLoading {
                    ProgressView()
                        .offset(y: 30)
                } else if vm.lastImages {
                    Text("No more images available")
                        .foregroundColor(.gray)
                        .offset(y: 30)
                }
            })
            .padding(15)
            .padding(.bottom, 15)
        }
        .alert(item: $vm.viewModelError) { error in
            Alert(
                title: Text(error.errorMessage),
                message: Text(""),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

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
                let fetchedImages = try await service.performFetch(for: currentPage, pageLimit: numberOfImagesPerPage, fromBundle: "MockImages")
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

// MARK: - APIRequestBuilder Protocol
protocol APIRequestBuilder {
    func buildRequest(for page: Int, pageLimit: Int, method: HTTPMethod) -> URLRequest?
}
// MARK: - HTTPMethod Enum
enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}
// MARK: - ImagesRequestBuilder
class ImagesRequestBuilder: APIRequestBuilder {
    private let baseURL: String
    
    init(baseURL: String = "https://picsum.photos") {
        self.baseURL = baseURL
    }
    
    func buildRequest(for page: Int, pageLimit: Int, method: HTTPMethod) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)/v2/list?page=\(page)&limit=\(pageLimit)") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
// MARK: - APIService Protocol
protocol APIService {
    func performFetch(for page: Int, pageLimit: Int) async throws -> [ImageModel]
    func performFetch(for page: Int, pageLimit: Int, fromBundle bundleName: String) async throws -> [ImageModel]
}
// MARK: - ImagesService
class ImagesService: BaseAPIService<[ImageModel]>, APIService {
    func performFetch(for page: Int, pageLimit: Int) async throws -> [ImageModel] {
        return try await performRequest(for: page, pageLimit: pageLimit, method: .GET)
    }
    
    func performFetch(for page: Int, pageLimit: Int, fromBundle bundleName: String) async throws -> [ImageModel] {
        return try loadFromBundle(bundleName)
    }
    
    private func loadFromBundle(_ bundleName: String) throws -> [ImageModel] {
        guard let url = Bundle.main.url(forResource: bundleName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw ServiceError.invalidURL
        }
        
        return try decode(data)
    }
}
// MARK: - BaseAPIService
class BaseAPIService<T: Decodable> {
    let networkManager: Network
    let requestBuilder: APIRequestBuilder
    let bundleManager: BundleManager? // Optional BundleManager for JSON loading
    
    init(networkManager: Network, requestBuilder: APIRequestBuilder, bundleManager: BundleManager? = nil) {
        self.networkManager = networkManager
        self.requestBuilder = requestBuilder
        self.bundleManager = bundleManager
    }
    
    func performRequest(for page: Int, pageLimit: Int, method: HTTPMethod, fromBundle fileName: String? = nil) async throws -> T {
        
        guard let request = requestBuilder.buildRequest(for: page, pageLimit: pageLimit, method: method) else {
            throw ServiceError.invalidURL
        }
        
        let (data, response) = try await networkManager.performRequest(request)
        try networkManager.validateResponse(response)
        
        return try decode(data)
    }
    
    func decode(_ data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ServiceError.decodingError("Failed to decode data")
        }
    }
}
// MARK: - ServiceError
enum ServiceError: Error {
    case networkError(NetworkError)  // Wrap NetworkError for clarity
    case decodingError(String)
    case unknownError(String)
    case invalidURL
    
    var localizedDescription: String {
        switch self {
        case .networkError(let networkingError):
            return networkingError.localizedDescription
        case .decodingError(let message):
            return "Decoding Error: \(message)"
        case .unknownError(let message):
            return "Unknown Error: \(message)"
        case .invalidURL:
            return "The URL provided is invalid."
        }
    }
}

// MARK: - Network Protocol
protocol Network {
    func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse)
    func validateResponse(_ response: URLResponse) throws
}

// MARK: - NetworkManager
class NetworkManager: Network {
    func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return (data, response)
        } catch {
            throw NetworkError.networkFailure("Failed to execute request.")
        }
    }
    
    func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(-1) // Throw an error for non-HTTP responses
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse(httpResponse.statusCode)
        }
    }
}
// MARK: - NetworkError
enum NetworkError: Error, Equatable {
    case networkFailure(String)
    case invalidResponse(Int)
    
    var localizedDescription: String {
        switch self {
        case .networkFailure(let message):
            return "Network failure: \(message)"
        case .invalidResponse(let statusCode):
            return "Invalid response with status code: \(statusCode)"
        }
    }
}
// MARK: - BundleManager Protocol
protocol BundleManager {
    func loadJSONData(from fileName: String) throws -> Data
}

// MARK: - Default BundleManager
class DefaultBundleManager: BundleManager {
    func loadJSONData(from fileName: String) throws -> Data {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw BundleError.fileNotFound(fileName)
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            throw BundleError.failedToLoadData(fileName)
        }
    }
}
// MARK: - BundleError
enum BundleError: Error {
    case fileNotFound(String)
    case failedToLoadData(String)
    
    var localizedDescription: String {
        switch self {
        case .fileNotFound(let fileName):
            return "File not found: \(fileName)"
        case .failedToLoadData(let fileName):
            return "Failed to load data from file: \(fileName)"
        }
    }
}

