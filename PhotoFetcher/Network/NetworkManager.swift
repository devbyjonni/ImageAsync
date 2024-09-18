
import Foundation
import os.log

struct NetworkManager: NetworkManaging {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func executeRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        LogMessages.networkExecutingRequest(url: request.url?.absoluteString ?? "No URL", method: request.httpMethod ?? "No method", functionName: #function)
        
        if let headers = request.allHTTPHeaderFields {
            LogMessages.networkRequestHeaders(headers: headers, functionName: #function)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            LogMessages.networkInvalidResponse(functionName: #function)
            throw NetworkError.invalidResponse(-1)
        }
        
        LogMessages.networkReceivedResponse(statusCode: httpResponse.statusCode, functionName: #function)
        
        switch httpResponse.statusCode {
        case 200...299:
            LogMessages.networkSuccessfulResponse(statusCode: httpResponse.statusCode, functionName: #function)
        case 401:
            LogMessages.networkUnauthorizedError(functionName: #function)
            throw NetworkError.invalidResponse(httpResponse.statusCode)
        case 404:
            LogMessages.networkResourceNotFound(functionName: #function)
            throw NetworkError.networkFailure("Resource not found")
        case 500...599:
            LogMessages.networkServerError(statusCode: httpResponse.statusCode, functionName: #function)
            throw NetworkError.serverError("Server error: \(httpResponse.statusCode) - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
        default:
            LogMessages.networkUnexpectedStatusCode(statusCode: httpResponse.statusCode, functionName: #function)
            throw NetworkError.invalidResponse(httpResponse.statusCode)
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            LogMessages.networkDecodingSuccess(functionName: #function)
            return decodedData
        } catch {
            LogMessages.networkDecodingError(error: error.localizedDescription, functionName: #function)
            throw NetworkError.decodingError("Failed to decode data: \(error.localizedDescription)")
        }
    }
}

//MARK: NetworkManager logging
extension LogMessages {
    static let networkLogger = Logger(subsystem: "com.photofetcher.network", category: "NetworkManager")
    
    static func networkExecutingRequest(url: String, method: String, functionName: String = #function) {
        networkLogger.info("[\(functionName)] - Executing request: \(url), Method: \(method)")
    }
    
    static func networkInvalidResponse(functionName: String = #function) {
        networkLogger.error("[\(functionName)] - Invalid response, not an HTTP response")
    }
    
    static func networkRequestHeaders(headers: [String: String], functionName: String = #function) {
        networkLogger.debug("[\(functionName)] - Request headers: \(headers)")
    }
    
    static func networkReceivedResponse(statusCode: Int, functionName: String = #function) {
        networkLogger.info("[\(functionName)] - Received response with status code: \(statusCode)")
    }
    
    static func networkSuccessfulResponse(statusCode: Int, functionName: String = #function) {
        networkLogger.debug("[\(functionName)] - Successful response with status code: \(statusCode)")
    }
    
    static func networkUnauthorizedError(functionName: String = #function) {
        networkLogger.error("[\(functionName)] - Unauthorized (401) error")
    }
    
    static func networkResourceNotFound(functionName: String = #function) {
        networkLogger.error("[\(functionName)] - Resource not found (404)")
    }
    
    static func networkServerError(statusCode: Int, functionName: String = #function) {
        networkLogger.error("[\(functionName)] - Server error: \(statusCode) - \(HTTPURLResponse.localizedString(forStatusCode: statusCode))")
    }
    
    static func networkUnexpectedStatusCode(statusCode: Int, functionName: String = #function) {
        networkLogger.error("[\(functionName)] - Unexpected status code: \(statusCode)")
    }
    
    static func networkDecodingSuccess(functionName: String = #function) {
        networkLogger.debug("[\(functionName)] - Successfully decoded response")
    }
    
    static func networkDecodingError(error: String, functionName: String = #function) {
        networkLogger.error("[\(functionName)] - Decoding error: \(error)")
    }
}


