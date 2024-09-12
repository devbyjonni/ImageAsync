//
//  ImageAsyncApp.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-09.
//

import SwiftUI

@main
struct ImageAsyncApp: App {
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
        let apiService = PicsumPhotosService(
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
