//
//  PicsumPhotosService.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-11.
//

import Foundation

class PicsumPhotosService: BaseAPIService<[PicsumPhoto]>, APIService {
    func performFetch(for page: Int, pageLimit: Int, source: DataSource) async throws -> [PicsumPhoto] {
        switch source {
        case .api:
            return try await performRequest(for: page, pageLimit: pageLimit, method: .GET)
        case .bundle(let name):
            return try loadFromBundle(bundleName: name)
        }
    }
    
    private func loadFromBundle(bundleName: String) throws -> [PicsumPhoto] {
        // Ensure the bundleManager is set (default to DefaultBundleManager if nil)
        let bundleManager = self.bundleManager ?? DefaultBundleManager()
        let data = try bundleManager.loadJSONData(from: bundleName)
 
        return try decode(data)
    }
}
