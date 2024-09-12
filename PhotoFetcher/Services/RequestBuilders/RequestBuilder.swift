//
//  RequestBuilder.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-11.
//

import Foundation

protocol RequestBuilder {
    
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
    ///
    ///
    func buildRequest(for page: Int, pageLimit: Int, method: HTTPMethod, headers: [String: String]?) -> URLRequest?
    
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
    func buildRequest(for page: Int, pageLimit: Int, method: HTTPMethod) -> URLRequest?
}
