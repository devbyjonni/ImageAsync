//
//  PicsumPhotosRequestBuilder.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-11.
//

import Foundation

class PicsumPhotosRequestBuilder: APIRequestBuilder {
    private let baseURL: String
    
    init(baseURL: String = "https://picsum.photos") {
        self.baseURL = baseURL
    }
    
    func buildRequest(for page: Int, pageLimit: Int, method: HTTPMethod) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)/v2/list?page=\(page)&limit=\(pageLimit)") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
