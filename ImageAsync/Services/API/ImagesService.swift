//
//  ImagesService.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-11.
//

import Foundation

// MARK: - APIService Protocol
protocol APIService {
    func performFetch(for page: Int, pageLimit: Int, source: DataSource) async throws -> [ImageModel]
}
// MARK: - ImagesService
class ImagesService: BaseAPIService<[ImageModel]>, APIService {
    func performFetch(for page: Int, pageLimit: Int, source: DataSource) async throws -> [ImageModel] {
        switch source {
        case .api:
            return try await performRequest(for: page, pageLimit: pageLimit, method: .GET)
        case .bundle(let name):
            return try loadFromBundle(bundleName: name)
        }
    }
    
    private func loadFromBundle(bundleName: String) throws -> [ImageModel] {
        // Ensure the bundleManager is set (default to DefaultBundleManager if nil)
        let bundleManager = self.bundleManager ?? DefaultBundleManager()
        let data = try bundleManager.loadJSONData(from: bundleName)
 
        return try decode(data)
    }
}
