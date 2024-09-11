//
//  APIRequestBuilder.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-11.
//

import Foundation


// MARK: - APIRequestBuilder Protocol
protocol APIRequestBuilder {
    func buildRequest(for page: Int, pageLimit: Int, method: HTTPMethod) -> URLRequest?
}
// MARK: - HTTPMethod Enum
enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}
