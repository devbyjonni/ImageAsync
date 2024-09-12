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
    
    /// Builds a `URLRequest` for fetching photos with pagination and optional HTTP headers.
    ///
    /// - Parameters:
    ///   - page: The page number to request.
    ///   - pageLimit: The number of items per page.
    ///   - method: The HTTP method (e.g., GET, POST).
    ///   - headers: A dictionary of HTTP headers to include in the request (optional).
    ///
    /// - Returns: A `URLRequest` configured with the specified parameters, or `nil` if the URL is invalid.
    ///
    /// # Example Usage with Headers:
    /// ```swift
    /// let requestBuilder = PicsumPhotosRequestBuilder()
    /// let headers = ["Authorization": "Bearer YOUR_TOKEN", "Content-Type": "application/json"]
    /// let request = requestBuilder.buildRequest(for: 1, pageLimit: 30, method: .GET, headers: headers)
    /// ```
    ///
    /// # Example Usage without Headers:
    /// ```swift
    /// let requestBuilder = PicsumPhotosRequestBuilder()
    /// let request = requestBuilder.buildRequest(for: 1, pageLimit: 30, method: .GET)
    /// ```
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

    /// Builds a `URLRequest` for fetching photos with pagination without requiring headers.
    ///
    /// - Parameters:
    ///   - page: The page number to request.
    ///   - pageLimit: The number of items per page.
    ///   - method: The HTTP method (e.g., GET, POST).
    ///
    /// - Returns: A `URLRequest` configured with the specified parameters, or `nil` if the URL is invalid.
    ///
    /// # Example Usage:
    /// ```swift
    /// let requestBuilder = PicsumPhotosRequestBuilder()
    /// let request = requestBuilder.buildRequest(for: 1, pageLimit: 30, method: .GET)
    /// ```
    func buildRequest(for page: Int, pageLimit: Int, method: HTTPMethod) -> URLRequest? {
        return buildRequest(for: page, pageLimit: pageLimit, method: method, headers: nil)
    }

}
