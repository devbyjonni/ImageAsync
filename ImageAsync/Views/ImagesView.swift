//
//  ImagesView.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-09.
//

import SwiftUI

struct ImagesView: View {
    // Bindings and Constants
    @Binding var pageInfo: String
    let loaderType: ImageLoaderType
    let imagesPerPage = 30

    // State Variables
    @State var page: Int = 1
    @State private var images: [ImageModel] = []
    @State private var lastFetchedPage = 1
    @State private var isLoading = false

    // Pagination
    @State private var hasNextPage = true
    @State private var activeImageID: String?
    @State private var lastImageID: String?

    // Error Handling
    @State private var errorMessage: String?
    @State private var showErrorAlert = false

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3), spacing: 10) {
                ForEach(images) { image in
                    ImageCardView(imageModel: image, loaderType: loaderType)
                }
            }
            .overlay(alignment: .bottom, content: {
                if isLoading {
                    ProgressView()
                        .offset(y: 30)
                }
            })
            .padding(15)
            .padding(.bottom, 15)
            .scrollTargetLayout()
        }
        .scrollPosition(id: Binding<String?>.init(get: {
            return ""
        }, set: { newValue in
            activeImageID = newValue
        }), anchor: .bottomTrailing)
        .onChange(of: activeImageID, { oldValue, newValue in
            if newValue == lastImageID, !isLoading, hasNextPage {
                page += 1
                fetchImages()
            }
        })
        .alert("Error", isPresented: $showErrorAlert, actions: {
            Button("Try Again") {
                fetchImages()
            }
            Button("Cancel", role: .cancel) { }
        }, message: {
            Text(errorMessage ?? "An unexpected error occurred")
        })
        .onAppear {
            fetchImages()
        }
    }
    
    private func fetchImages() {
        isLoading = true
        Task {
            do {
                let images = try await fetchImagesFromAPI(page: page)
                await MainActor.run {
                    self.images.append(contentsOf: images)
                    lastImageID = images.last?.id
                    isLoading = false
                }
            } catch let urlError as URLError {
                await MainActor.run {
                    errorMessage = """
                    Network error: \(urlError.localizedDescription).
                    Please check your internet connection and try again.
                    """
                    showErrorAlert = true
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = """
                    Failed to load images. Please try again later.
                    Error: \(error.localizedDescription)
                    """
                    showErrorAlert = true
                    isLoading = false
                }
            }
        }
    }

    private func buildAPIURL(page: Int) -> URL? {
        return URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=\(imagesPerPage)")
    }

    private func fetchImagesFromAPI(page: Int) async throws -> [ImageModel] {
        guard let url = buildAPIURL(page: page) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        let images = try JSONDecoder().decode([ImageModel].self, from: data)
        
        handlePagination(response: response)

        return images
    }

    // Function to handle pagination by checking the "Link" header
    private func handlePagination(response: URLResponse) {
        if let httpResponse = response as? HTTPURLResponse,
           let linkHeader = httpResponse.value(forHTTPHeaderField: "Link") {

            // Check if the "next" page exists in the Link header
            hasNextPage = linkHeader.contains("rel=\"next\"")
            pageInfo = hasNextPage ? "Loaded images: (\(page * imagesPerPage))" : "All images loaded"
        }
    }
}

#Preview {
    HomeView()
}
