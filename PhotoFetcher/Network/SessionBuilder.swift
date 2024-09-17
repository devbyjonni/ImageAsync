import Foundation
import os.log

protocol SessionBuilding {
    func buildSession() -> URLSession
    func buildForegroundSession() -> URLSession
    func buildBackgroundSession(identifier: String) -> URLSession
}

struct SessionBuilder: SessionBuilding {
    func buildCustomSession(with headers: [String: String]) -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        configuration.timeoutIntervalForRequest = 30
        LogMessages.sessionCustomSessionCreated(headers: headers, functionName: #function)
        return URLSession(configuration: configuration)
    }
    
    func buildSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.allowsCellularAccess = true
        LogMessages.sessionDefaultSessionCreated(allowsCellularAccess: configuration.allowsCellularAccess, functionName: #function)
        return URLSession(configuration: configuration)
    }
    
    func buildForegroundSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 20
        configuration.allowsCellularAccess = true
        LogMessages.sessionForegroundSessionCreated(allowsCellularAccess: configuration.allowsCellularAccess, functionName: #function)
        return URLSession(configuration: configuration)
    }
    
    func buildBackgroundSession(identifier: String) -> URLSession {
        let configuration = URLSessionConfiguration.background(withIdentifier: identifier)
        configuration.isDiscretionary = true
        LogMessages.sessionBackgroundSessionCreated(identifier: identifier, isDiscretionary: configuration.isDiscretionary, functionName: #function)
        return URLSession(configuration: configuration)
    }
}

//MARK: SessionBuilder logging
extension LogMessages {
    static let sessionLogger = Logger(subsystem: "com.yourapp.network", category: "SessionBuilder")
    
    static func sessionCustomSessionCreated(headers: [String: String], functionName: String = #function) {
        sessionLogger.info("[\(functionName)] - Custom session created with headers: \(headers, privacy: .private). Timeout: 30 seconds.")
    }
    
    static func sessionDefaultSessionCreated(allowsCellularAccess: Bool, functionName: String = #function) {
        sessionLogger.info("[\(functionName)] - Default session created. Timeout: 30 seconds. Cellular access: \(allowsCellularAccess)")
    }
    
    static func sessionForegroundSessionCreated(allowsCellularAccess: Bool, functionName: String = #function) {
        sessionLogger.info("[\(functionName)] - Foreground session (ephemeral) created. Timeout: 20 seconds. Cellular access: \(allowsCellularAccess)")
    }
    
    static func sessionBackgroundSessionCreated(identifier: String, isDiscretionary: Bool, functionName: String = #function) {
        sessionLogger.info("[\(functionName)] - Background session created with identifier: \(identifier). Discretionary: \(isDiscretionary)")
    }
}


