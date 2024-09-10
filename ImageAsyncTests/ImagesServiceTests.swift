//
//  ImagesServiceTests.swift
//  ImageAsyncTests
//
//  Created by Jonni Akesson on 2024-09-10.
//

import XCTest
@testable import ImageAsync

final class ImagesServiceTests: XCTestCase {

    override func setUpWithError() throws {

    }
    
    override func tearDownWithError() throws {

    }

    func testImagesServiceSuccessfulFetch() async throws {
        // Given: A valid page and page limit
        let page = 1
        let pageLimit = 30
        
        // Mock response data (as JSON)
        let imageData = """
        [
            {
                "id": "1",
                "author": "Author1",
                "url": "https://example.com/1",
                "download_url": "https://example.com/1"
            },
            {
                "id": "2",
                "author": "Author2",
                "url": "https://example.com/2",
                "download_url": "https://example.com/2"
            }
        ]
        """.data(using: .utf8)!
        
        // Mock NetworkingManager to return this image data
        let mockNetworkingManager = MockNetworkingManager(mockData: imageData)
        let imagesService = ImagesService(networkingManager: mockNetworkingManager, urlBuilder: ImagesURLBuilder())
        
        // When: Fetching images from the service
        do {
            let images = try await imagesService.fetchImages(for: page, pageLimit: pageLimit)
            
            // Then: Validate that images are fetched successfully
            XCTAssertEqual(images.count, 2, "The number of fetched images should match the mock data.")
            XCTAssertEqual(images.first?.id, "1", "The first image ID should match.")
        } catch {
            XCTFail("Unexpected error occurred: \(error.localizedDescription)")
        }
    }
    
    func testImagesServiceFetchFailureEnsureServiceErrorWrappingNetworkingError() async throws {
        // Given: A failure scenario due to a network error
        let mockNetworkingManager = MockNetworkingManager(mockError: NetworkingError.invalidURL)
        let imagesService = ImagesService(networkingManager: mockNetworkingManager, urlBuilder: ImagesURLBuilder())
        
        // When: Fetching images from the service
        do {
            _ = try await imagesService.fetchImages(for: 1, pageLimit: 30)
        } catch let error as ServiceError {
            // Ensure the error is a ServiceError wrapping the NetworkingError
            
            print("\(error.localizedDescription)")
            print("\(ServiceError.networkError(.invalidURL).localizedDescription)")
            XCTAssertEqual(error.localizedDescription, ServiceError.networkError(.invalidURL).localizedDescription, "Error message should match the expected NetworkingError.")
        } catch {
            XCTFail("Unexpected error occurred: \(error.localizedDescription)")
        }
    }
}

// MARK: - MockNetworkingManager
class MockNetworkingManager: Networking {
    var mockData: Data?
    var mockError: Error?
    
    init(mockData: Data? = nil, mockError: Error? = nil) {
        self.mockData = mockData
        self.mockError = mockError
    }
    
    func loadData(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error  // Make sure error is thrown here
        }
        return (mockData ?? Data(), HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }
    
    func validateResponse(_ response: URLResponse) throws {
        if let error = mockError {
            throw error  // Make sure error is thrown here
        }
    }
}
