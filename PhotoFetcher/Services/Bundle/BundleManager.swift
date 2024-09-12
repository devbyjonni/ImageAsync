//
//  BundleManager.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-11.
//

import Foundation

protocol BundleManager {
    func loadJSONData(from fileName: String) throws -> Data
}
