//
//  NetworkingManagerTests.swift
//  ImageAsyncTests
//
//  Created by Jonni Akesson on 2024-09-10.
//

import XCTest
@testable import ImageAsync

final class NetworkingManagerTests: XCTestCase {
    
    private var service: Service!
    private var networkingManager: NetworkingManager!
    private var urlBuilder: URLBuilder!
    
    override func setUpWithError() throws {
        self.networkingManager = NetworkingManager()
        self.urlBuilder = ImagesURLBuilder()
        self.service = ImagesService(networkingManager: networkingManager, urlBuilder: urlBuilder)
    }
    
    override func tearDownWithError() throws {
        self.networkingManager = nil
        self.urlBuilder = nil
        self.service = nil
    }
    
    // MARK: - Test NetworkingManager
    func testNetworkingManagerSuccessfulLoadData() async throws {
        // Given: A valid image URL
        let imageURL = URL(string: "https://picsum.photos/id/1/256/256.jpg")!
        
        // When: Fetching data from the image URL
        do {
            let (data, _) = try await networkingManager.loadData(from: imageURL)
            
            // Then: Assert that data and response are not nil and valid
            XCTAssertNotNil(data, "Data should not be nil")
            XCTAssertGreaterThan(data.count, 0, "Data should not be empty") // Assert that data size is greater than 0
        } catch let error as NetworkingError {
            // Then: No error should occur if the response is valid
            XCTFail("Unexpected NetworkingError occurred: \(error.localizedDescription)")
        } catch {
            // Handle any other unexpected errors
            XCTFail("Unexpected error occurred: \(error.localizedDescription)")
        }
    }
    
    
    func testNetworkingManagerValidateResponse() async throws {
        // Given: A valid image URL and an HTTPURLResponse with a valid status code (e.g., 200)
        let imageURL = URL(string: "https://picsum.photos/id/1/256/256.jpg")!
        let httpResponse = HTTPURLResponse(
            url: imageURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        // When: Validating the HTTP response
        do {
            try networkingManager.validateResponse(httpResponse)
        } catch let error as NetworkingError {
            // Then: No error should occur if the response is valid
            XCTFail("Unexpected NetworkingError occurred: \(error.localizedDescription)")
        } catch {
            // Handle any other unexpected errors
            XCTFail("Unexpected error occurred: \(error.localizedDescription)")
        }
    }
}
