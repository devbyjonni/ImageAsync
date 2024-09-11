//
//  BundleManagerTests.swift
//  ImageAsyncTests
//
//  Created by Jonni Akesson on 2024-09-11.
//

import XCTest
@testable import ImageAsync

// Mock BundleManager for Testing
class MockBundleManager: BundleManager {
    var mockData: Data?
    var mockError: BundleError?

    func loadJSONData(from fileName: String) throws -> Data {
        if let error = mockError {
            throw error
        }
        guard let data = mockData else {
            throw BundleError.fileNotFound(fileName)
        }
        return data
    }
}


final class BundleManagerTests: XCTestCase {
    var bundleManager: MockBundleManager!
    
    override func setUpWithError() throws {
        // Initialize the mock bundle manager before each test
        bundleManager = MockBundleManager()
    }
    
    override func tearDownWithError() throws {
        // Clean up after each test
        bundleManager = nil
    }
    
    // Test case for successfully loading data from the bundle
    func testLoadJSONData_Success() throws {
        // Given: A valid file and mock data
        let expectedData = "{\"key\": \"value\"}".data(using: .utf8)
        bundleManager.mockData = expectedData
        
        // When: Loading the data
        let data = try bundleManager.loadJSONData(from: "TestFile")
        
        // Then: The data should match the expected mock data
        XCTAssertEqual(data, expectedData, "The loaded data should match the mock data.")
    }
    
    // Test case for a missing file
    func testLoadJSONData_FileNotFound() throws {
        // Given: No mock data to simulate a missing file
        bundleManager.mockData = nil
        
        // When: Attempting to load data from a non-existent file
        XCTAssertThrowsError(try bundleManager.loadJSONData(from: "MissingFile")) { error in
            // Then: The error should be a file not found error
            XCTAssertEqual((error as? BundleError), BundleError.fileNotFound("MissingFile"), "The error should indicate the file was not found.")
        }
    }
    
    // Test case for failing to load data from a file
    func testLoadJSONData_FailedToLoadData() throws {
        // Given: Simulate a failure to load data
        bundleManager.mockError = .failedToLoadData("TestFile")
        
        // When: Attempting to load data from the bundle
        XCTAssertThrowsError(try bundleManager.loadJSONData(from: "TestFile")) { error in
            // Then: The error should be a failed to load data error
            XCTAssertEqual((error as? BundleError), BundleError.failedToLoadData("TestFile"), "The error should indicate a failure to load data.")
        }
    }
}
