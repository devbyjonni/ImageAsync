//
//  PhotoFetcherApp.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-09.
//

import SwiftUI
import os.log

@main
struct PhotoFetcherApp: App {
    @Environment(\.scenePhase) var scenePhase

    init() {
        LogMessages.appDidLaunch(functionName: #function)
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    LogMessages.mainViewDisplayed(functionName: #function)
                }
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                LogMessages.appBecameActive(functionName: #function)
            case .inactive:
                LogMessages.appBecameInactive(functionName: #function)
            case .background:
                LogMessages.appEnteredBackground(functionName: #function)
            default:
                break
            }
        }
    }
}

final class DependencyContainer: ObservableObject {
    private(set) var repository: PhotoRepository

    init() {
        LogMessages.dependencyContainerInit(functionName: #function)
        
        let requestBuilder = RequestBuilder()
        let sessionBuilder = SessionBuilder()
        let session = sessionBuilder.buildForegroundSession()
        let networkManager = NetworkManager(session: session)
        let paginatedFetcher = PaginatedFetcher(requestBuilder: requestBuilder,
                                                networkManager: networkManager)
        
        let apiService = PhotoAPIService(fetcher: paginatedFetcher,
                                         requestBuilder: requestBuilder,
                                         networkManager: networkManager)
        
        self.repository = PhotoRepository(apiService: apiService)
    }
}

// MARK: - DependencyContainer Logging
extension LogMessages {
    static let dependencyLogger = Logger(subsystem: "com.yourapp.dependency", category: "DependencyContainer")
    
    static func dependencyContainerInit(functionName: String = #function) {
        dependencyLogger.info("[\(functionName)] - DependencyContainer has been initialized.")
    }
}
