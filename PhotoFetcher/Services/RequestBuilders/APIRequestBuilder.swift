//
//  APIRequestBuilder.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-11.
//

import Foundation

protocol APIRequestBuilder {
    func buildRequest(for page: Int, pageLimit: Int, method: HTTPMethod) -> URLRequest?
}
