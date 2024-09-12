//
//  HomeView.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-09.
//

import SwiftUI

struct HomeView: View {

    var body: some View {
        NavigationStack {
            PhotosGridView()
                .navigationTitle("PhotosGridView")
        }
    }
}

#Preview {
     HomeView()
        .environmentObject(DependencyContainer().viewModel)
}
