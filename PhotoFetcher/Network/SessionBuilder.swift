//
//  SessionBuilder.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-12.
//

import Foundation

class SessionBuilder {
    
    private var configuration: URLSessionConfiguration = .default
    
    /// Configures a `URLSession` with the default configuration.
    ///
    /// - `default`: This session configuration uses the device's default network settings, which includes persistent storage for cookies, caches, and credentials.
    ///
    /// This configuration is suitable for most standard networking tasks where the session should manage cookies, caches, and credentials automatically across requests.
    ///
    /// - Returns: The `SessionBuilder` instance, allowing method chaining for further configurations.
    func withDefaultConfiguration() -> SessionBuilder {
        self.configuration = URLSessionConfiguration.default
        return self
    }
    
    /// Configures a `URLSession` for foreground tasks requiring low latency, such as real-time or near real-time data fetching.
    ///
    /// - `ephemeral`: This session configuration does not store cookies, cache, or credentials persistently, making it ideal for tasks where privacy is important, or where storing session data is unnecessary.
    ///
    /// - `networkServiceType`: Set to `.responsiveData` to prioritize low-latency data requests. This is useful for real-time or near real-time data fetching, where fast response time is more important than large data throughput.
    ///
    /// - `waitsForConnectivity`: Set to `true` to ensure that the session waits for connectivity rather than failing immediately if the network is unavailable. This is particularly useful in areas with poor connectivity, ensuring the request waits until connectivity is restored.
    ///
    /// - `timeoutIntervalForRequest`: Set to `30` seconds to define how long a request should wait for a response before timing out. This ensures that the app doesn't hang indefinitely if the server is slow or unresponsive.
    ///
    /// - `timeoutIntervalForResource`: Set to `60` seconds to define the maximum amount of time a resource request can take. This ensures that large or slow resources (like images) have a reasonable timeout without affecting the user experience.
    ///
    /// - Returns: The `SessionBuilder` instance, allowing method chaining for further configurations.
    func withForegroundConfiguration() -> SessionBuilder {
        self.configuration = URLSessionConfiguration.ephemeral
        self.configuration.networkServiceType = .responsiveData
        self.configuration.waitsForConnectivity = true
        self.configuration.timeoutIntervalForRequest = 30 // 30 seconds
        self.configuration.timeoutIntervalForResource = 60 // 60 seconds
        return self
    }
    
    // MARK: - Build Session
    func build() -> URLSession {
        return URLSession(configuration: configuration)
    }
}

