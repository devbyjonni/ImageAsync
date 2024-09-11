//
//  ImagesGridView.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-09.
//

import SwiftUI

// MARK: - ImagesGridView
struct ImagesGridView: View {
    @StateObject var vm = ImagesGridViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 10), count: UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2)

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(vm.images) { image in
                    ImageCardView(imageModel: image)
                        .onAppear {
                            // When the last image appears, trigger pagination
                            if image.id == vm.images.last?.id {
                                vm.loadImages()
                            }
                        }
                }
            }
            .overlay(alignment: .bottom, content: {
                if vm.isLoading {
                    ProgressView()
                        .offset(y: 30)
                } else if vm.lastImages {
                    Text("No more images available")
                        .foregroundColor(.gray)
                        .offset(y: 30)
                }
            })
            .padding(15)
            .padding(.bottom, 15)
        }
        .alert(item: $vm.viewModelError) { error in
            Alert(
                title: Text(error.errorMessage),
                message: Text(""),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
