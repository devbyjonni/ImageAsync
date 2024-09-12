//
//  DefaultBundleManager.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-12.
//

import Foundation

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
