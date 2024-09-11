//
//  APIServiceTests.swift
//  ImageAsyncTests
//
//  Created by Jonni Akesson on 2024-09-11.
//

import XCTest
@testable import ImageAsync

class MockNetworkManager: Network {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData, let response = mockResponse else {
            throw NetworkError.networkFailure("No mock data or response provided.")
        }
        
        return (data, response)
    }
    
    func validateResponse(_ response: URLResponse) throws {
        // You can simulate response validation failure here if needed.
    }
}

final class APIServiceTests: XCTestCase {
    var service: ImagesService!
    var mockNetworkManager: MockNetworkManager!
    var mockBundleManager: MockBundleManager!
    
    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager()
        mockBundleManager = MockBundleManager()
        service = ImagesService(
            networkManager: mockNetworkManager,
            requestBuilder: ImagesRequestBuilder(),
            bundleManager: mockBundleManager
        )
    }
    
    override func tearDownWithError() throws {
        mockNetworkManager = nil
        mockBundleManager = nil
        service = nil
    }
    // Test API Fetching
    func testPerformFetch_FromAPI_Success() async throws {
        // Given: Mock valid data and response
        let mockImageModel = ImageModel(id: "1", author: "John Doe", url: "https://example.com", downloadURL: "https://example.com/download")
        let mockData = try! JSONEncoder().encode([mockImageModel])
        
        // Mocking the network manager to return mock data and a successful HTTP response
        mockNetworkManager.mockData = mockData
        mockNetworkManager.mockResponse = HTTPURLResponse(url: URL(string: "https://picsum.photos")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // When: Perform the fetch
        let fetchedImages = try await service.performFetch(for: 1, pageLimit: 30, source: .api)
        
        // Then: Validate the results
        XCTAssertEqual(fetchedImages.count, 1)  // Should fetch exactly 1 image
        XCTAssertEqual(fetchedImages.first?.author, "John Doe")  // The author should match the mock data
        XCTAssertEqual(fetchedImages.first?.downloadURL, "https://example.com/download")  // The download URL should match
    }


    // Test API Failure (Network Error)
    func testPerformFetch_FromAPI_Failure() async throws {
        // Given: Simulate network failure
        mockNetworkManager.mockError = NetworkError.networkFailure("Network error")
        
        // When: Perform the fetch and expect failure
        do {
            _ = try await service.performFetch(for: 1, pageLimit: 30, source: .api)
            XCTFail("Expected network failure but succeeded.")
        } catch let error as ServiceError {
            XCTAssertEqual(error.localizedDescription, "Network failure: Network error")
        }
    }
}

// Test Bundle Fetching
extension APIServiceTests {

    // Test successful fetching from the bundle
    func testPerformFetch_FromBundle_Success() async throws {
        // Given: Mock bundle data (a sample ImageModel encoded to JSON format)
        // We create a mock ImageModel to simulate a valid JSON file in the bundle
        let mockImageModel = ImageModel(id: "1", author: "John Doe", url: "https://example.com", downloadURL: "https://example.com/download")
        
        // Encoding the mock ImageModel into JSON format and setting it as the bundle data
        let mockBundleData = try! JSONEncoder().encode([mockImageModel]) // Encode an array of ImageModel
      //  mockBundleManager.mockData = mockBundleData // Set the mock data to simulate a valid bundle
        
        
        let mockNetworkManager = MockNetworkManager()
        let mockBundleManager = MockBundleManager()
        mockBundleManager.mockData = mockBundleData //
        let service = ImagesService(
            networkManager: mockNetworkManager,
            requestBuilder: ImagesRequestBuilder(),
            bundleManager: mockBundleManager
        )
      
        // When: Perform the fetch from the bundle (this will use the mock data we set up)
        let fetchedImages = try await service.performFetch(for: 1, pageLimit: 30, source: .bundle(name: "TestImages"))
        
        print(fetchedImages.count)

        // Then: Validate that the fetch was successful and the data matches the mock data
        XCTAssertEqual(fetchedImages.count, 1)  // Ensure that exactly one image is fetched
        XCTAssertEqual(fetchedImages.first?.author, "John Doe")  // Ensure the author matches the mock data
        XCTAssertEqual(fetchedImages.first?.downloadURL, "https://example.com/download")  // Ensure the download URL matches the mock data
    }

    // Test failure when loading from the bundle
    func testPerformFetch_FromBundle_Failure() async throws {
        // Given: Simulate bundle loading failure (e.g., the JSON file doesn't exist)
        // We use the mockBundleManager to simulate an error when trying to load a file
        mockBundleManager.mockError = BundleError.fileNotFound("TestImages") // Simulate that the file is not found

        // When: Perform the fetch and expect it to fail due to the simulated error
        // We attempt to fetch images from the bundle, but it should fail due to the file not being found
        do {
            _ = try await service.performFetch(for: 1, pageLimit: 30, source: .bundle(name: "TestImages"))
            XCTFail("Expected bundle failure but succeeded.")  // Fail the test if no error occurs (because we expect failure)
        } catch let error as BundleError {
            // Then: Validate that the error matches the expected BundleError
            XCTAssertEqual(error.localizedDescription, "File not found: TestImages")  // Ensure the error message is correct
        }
    }
}

