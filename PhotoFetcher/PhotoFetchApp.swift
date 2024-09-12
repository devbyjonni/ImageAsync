//
//  PhotoFetcherApp.swift
//  PhotoFetcher
//
//  Created by Jonni Akesson on 2024-09-09.
//

import SwiftUI

@main
struct PhotoFetcherApp: App {
    @StateObject private var container = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(container.viewModel)
        }
    }
}

@MainActor
final class DependencyContainer: ObservableObject {
    let apiService: APIService
    let persistenceService: PersistenceService
    let photoRepository: PhotoRepository
    var viewModel: PhotosGridViewModel
    
    init() {
        let apiService = PhotoService(
            networkManager: NetworkManager(),
            requestBuilder: PicsumPhotosRequestBuilder()
        )
        let persistenceService = CoreDataService()
        let photoRepository = DefaultPhotoRepository(apiService: apiService, persistenceService: persistenceService)
        self.apiService = apiService
        self.persistenceService = persistenceService
        self.photoRepository = photoRepository
        self.viewModel = PhotosGridViewModel(photoRepository: photoRepository)
    }
}
