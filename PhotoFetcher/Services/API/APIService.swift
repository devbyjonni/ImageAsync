//
//  APIService.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-12.
//

import Foundation

protocol APIService {
    associatedtype Model: Decodable
    func performRequest(for page: Int, pageLimit: Int, method: HTTPMethod) async throws -> Model
}
