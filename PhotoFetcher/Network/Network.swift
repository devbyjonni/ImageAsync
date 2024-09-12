//
//  Network.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-12.
//

import Foundation

protocol Network {
    func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse)
    func validateResponse(_ response: URLResponse) throws
}
