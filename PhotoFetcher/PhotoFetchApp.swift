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
    let apiService: any APIService
    let persistenceService: PersistenceService
    let picsumPhotoRepository: Repository
    var viewModel: PhotosGridViewModel
    
    init() {
        let apiService = PicsumPhotosService()
        let persistenceService = CoreDataService()
        let picsumPhotoRepository = PicsumPhotoRepository(apiService: apiService, persistenceService: persistenceService)
        
        self.apiService = apiService
        self.persistenceService = persistenceService
        self.picsumPhotoRepository = picsumPhotoRepository
        self.viewModel = PhotosGridViewModel(picsumPhotosService: picsumPhotoRepository)
    }
}
