//
//  BundleManager.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-11.
//

import Foundation

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
enum BundleError: Error, Equatable {
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
    
    // Equatable conformance
    // BundleError can now be compared using XCTAssertEqual.
    static func == (lhs: BundleError, rhs: BundleError) -> Bool {
        switch (lhs, rhs) {
        case (.fileNotFound(let lhsFile), .fileNotFound(let rhsFile)):
            return lhsFile == rhsFile
        case (.failedToLoadData(let lhsFile), .failedToLoadData(let rhsFile)):
            return lhsFile == rhsFile
        default:
            return false
        }
    }
}
