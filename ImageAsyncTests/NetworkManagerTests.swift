//
//  NetworkManagerTests.swift
//  ImageAsyncTests
//
//  Created by Jonni Akesson on 2024-09-11.
//

import XCTest
@testable import ImageAsync

// Mock URLProtocol to simulate network behavior
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Request handler is not set.")
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

// Test Class for NetworkManager
final class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        
        // Create a URLSession configuration using the ephemeral session configuration.
        // Ephemeral configuration means it does not cache any data to disk (useful for tests).
        let config = URLSessionConfiguration.ephemeral
        
        // Set the protocolClasses to [MockURLProtocol], so we can intercept and mock the requests.
        config.protocolClasses = [MockURLProtocol.self]
        
        // Initialize a URLSession with the above configuration.
        let session = URLSession(configuration: config)
        
        // Inject the mock session into NetworkManager. This allows us to control the responses.
        networkManager = NetworkManager(session: session)
    }
    
    override func tearDown() {
        // Clean up after each test to release resources and avoid test pollution.
        networkManager = nil
        super.tearDown()
    }
    
    // Test case: Verifies that a successful network request returns the correct data and response.
    func testPerformRequest_Success() async throws {
        // Given: A test URL and mock response data
        let testURL = URL(string: "https://example.com")!
        
        // Create some mock data to return (in this case, "Success" string).
        let expectedData = "Success".data(using: .utf8)!
        
        // Create a mock HTTPURLResponse with status code 200 (success).
        let expectedResponse = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        // Set up the mock URL protocol to return this response when the request is made.
        MockURLProtocol.requestHandler = { _ in
            return (expectedResponse, expectedData)
        }
        
        // When: A network request is made using the mock session.
        let request = URLRequest(url: testURL)
        let (data, response) = try await networkManager.performRequest(request)
        
        // Then: The data returned should match the mock data and the status code should be 200.
        XCTAssertEqual(data, expectedData, "The data should match the expected mock data.")
        XCTAssertEqual((response as? HTTPURLResponse)?.statusCode, 200, "The response status code should be 200.")
    }
    
    // Test case: Verifies that a failed network request correctly throws an error.
    func testPerformRequest_Failure() async throws {
        // Given: A test URL and a mock error to simulate network failure.
        let testURL = URL(string: "https://example.com")!
        
        // Create a mock error (e.g., request timeout).
        let expectedError = NSError(domain: "TestError", code: -1001, userInfo: nil)
        
        // Set up the mock URL protocol to throw this error when the request is made.
        MockURLProtocol.requestHandler = { _ in
            throw expectedError
        }
        
        // When: A network request is made
        let request = URLRequest(url: testURL)
        
        // Then: We expect the network request to fail and throw an error.
        do {
            _ = try await networkManager.performRequest(request)
            XCTFail("Expected an error to be thrown") // Fail if no error is thrown.
        } catch let error as NetworkError {
            // Check if it's a NetworkError and assert on its message.
            switch error {
            case .networkFailure(let message):
                XCTAssertEqual(message, "Failed to execute request.", "The network failure message should match the expected failure message.")
            default:
                XCTFail("Unexpected NetworkError type encountered.")
            }
        } catch {
            // This checks for unexpected errors, like if it's an NSError or anything else.
            XCTFail("Unexpected error occurred: \(error)")
        }
    }

    
    // Test case: Verifies that a valid HTTP response passes validation successfully.
    func testValidateResponse_Success() throws {
        // Given: A test URL and a valid HTTPURLResponse with status code 200.
        let testURL = URL(string: "https://example.com")!
        let validResponse = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        // When/Then: The validation should pass without throwing any errors.
        XCTAssertNoThrow(try networkManager.validateResponse(validResponse), "The response should be valid and pass the validation.")
    }
    
    // Test case: Verifies that an invalid HTTP response correctly throws a validation error.
    func testValidateResponse_Invalid() throws {
        // Given: A test URL and an invalid HTTPURLResponse with status code 404 (Not Found).
        let testURL = URL(string: "https://example.com")!
        let invalidResponse = HTTPURLResponse(url: testURL, statusCode: 404, httpVersion: nil, headerFields: nil)!
        
        // When: The response validation is attempted.
        // Then: It should throw an error with a specific NetworkError.invalidResponse.
        XCTAssertThrowsError(try networkManager.validateResponse(invalidResponse)) { error in
            XCTAssertEqual((error as? NetworkError), .invalidResponse(404), "The error should be an invalid response error with status code 404.")
        }
    }
}

