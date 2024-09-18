//
//  photofetcher.swift
//  photofetcher
//
//  Created by Jonni Akesson on 2024-09-09.
//

import SwiftUI
import os.log

@main
struct photofetcher: App {
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

// MARK: - photofetcher Logging
extension LogMessages {
    static let appLogger = Logger(subsystem: "com.photofetcher.app", category: "AppLifecycle")
    
    static func appDidLaunch(functionName: String = #function) {
        appLogger.info("[\(functionName)] - App has launched.")
    }
    
    static func mainViewDisplayed(functionName: String = #function) {
        appLogger.info("[\(functionName)] - MainView has been displayed.")
    }
    
    static func appBecameActive(functionName: String = #function) {
        appLogger.info("[\(functionName)] - App became active.")
    }

    static func appBecameInactive(functionName: String = #function) {
        appLogger.info("[\(functionName)] - App became inactive.")
    }
    
    static func appEnteredBackground(functionName: String = #function) {
        appLogger.info("[\(functionName)] - App entered background.")
    }
}
