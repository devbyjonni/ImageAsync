//
//  PhotosGridView.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-09.
//

import SwiftUI

struct PhotosGridView: View {
    @StateObject var vm = PhotosGridViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 10), count: UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2)

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(vm.picsumPhotos) { photo in
                    PhotoCardView(picsumPhoto: photo)
                        .onAppear {
                            // When the last photo appears, trigger pagination
                            if photo.id == vm.picsumPhotos.last?.id {
                                vm.loadData()
                            }
                        }
                }
            }
            .overlay(alignment: .bottom, content: {
                if vm.isLoading {
                    ProgressView()
                        .offset(y: 30)
                } else if vm.lastItem {
                    Text("No more photos available")
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
