//
//  APIService.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-12.
//

import Foundation

protocol APIService {
    func performFetch(for page: Int, pageLimit: Int, source: DataSource) async throws -> [PicsumPhoto]
}
