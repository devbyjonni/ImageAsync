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
            ImagesGridView()
                .navigationTitle("ImagesGridView")
        }
    }
}

#Preview {
    HomeView()
}
