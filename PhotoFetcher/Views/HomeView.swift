import SwiftUI
import os.log

struct MainView: View {
    
    init() {
        LogMessages.mainViewInit(functionName: #function)
    }
    
    var body: some View {
        TabView {
            PicsumPhotoGridView(viewModel: PicsumPhotoGridViewModel(dependency: DependencyContainer()))
                .tabItem {
                    Label("GridView", systemImage: "photo.on.rectangle")
                }
            PicsumPhotoListView(viewModel: PicsumPhotoListViewModel(dependency: DependencyContainer()))
                .tabItem {
                    Label("ListView", systemImage: "photo.on.rectangle")
                }
        }
    }
}

// MARK: - MainView Logging
extension LogMessages {
    static let mainViewLogger = Logger(subsystem: "com.yourapp.ui", category: "MainView")
    
    static func mainViewInit(functionName: String = #function) {
        mainViewLogger.info("[\(functionName)] - MainView has been initialized.")
    }
}


