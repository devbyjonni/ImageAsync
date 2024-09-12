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
    
    
    func buildRequest(for page: Int, pageLimit: Int, method: HTTPMethod, headers: [String: String]?) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)/v2/list?page=\(page)&limit=\(pageLimit)") else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }


    func buildRequest(for page: Int, pageLimit: Int, method: HTTPMethod) -> URLRequest? {
        return buildRequest(for: page, pageLimit: pageLimit, method: method, headers: nil)
    }

}
