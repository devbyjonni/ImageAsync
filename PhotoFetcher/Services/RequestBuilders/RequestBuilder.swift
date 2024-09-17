import Foundation
import os.log

enum RequestBuilderError: Error, Equatable {
    case invalidURL(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL(let urlString):
            return "Invalid URL: \(urlString)"
        }
    }
}

protocol RequestBuilding {
    func buildRequest(for page: Int, pageLimit: Int, method: HTTPMethod) throws -> URLRequest
}

struct RequestBuilder: RequestBuilding {
    private let baseURL: String
    
    init(baseURL: String = "https://picsum.photos") {
        self.baseURL = baseURL
    }
    
    func buildRequest(for page: Int, pageLimit: Int, method: HTTPMethod) throws -> URLRequest {
        LogMessages.requestBuildingRequest(page: page, pageLimit: pageLimit, method: method.rawValue, functionName: #function)
        
        let width = 50
        let height = 50
        let urlString = "\(baseURL)/v2/list?page=\(page)&limit=\(pageLimit)&width=\(width)&height=\(height)"
        
        guard let url = URL(string: urlString) else {
            LogMessages.requestInvalidURL(urlString: urlString, functionName: #function)
            throw RequestBuilderError.invalidURL(urlString)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        LogMessages.requestBuiltSuccessfully(urlString: urlString, functionName: #function)
        
        return request
    }
}

//MARK: RequestBuilder logging
extension LogMessages {
    static let requestBuilderLogger = Logger(subsystem: "com.yourapp.network", category: "RequestBuilder")
    
    static func requestBuildingRequest(page: Int, pageLimit: Int, method: String, functionName: String = #function) {
        requestBuilderLogger.info("[\(functionName)] - Building request for page: \(page), pageLimit: \(pageLimit), method: \(method)")
    }
    
    static func requestInvalidURL(urlString: String, functionName: String = #function) {
        requestBuilderLogger.error("[\(functionName)] - Invalid URL: \(urlString)")
    }
    
    static func requestBuiltSuccessfully(urlString: String, functionName: String = #function) {
        requestBuilderLogger.debug("[\(functionName)] - Successfully built request: \(urlString)")
    }
}


