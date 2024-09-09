//
//  HomeView.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-09.
//

import SwiftUI

struct HomeView: View {
    @State private var pageInfo: String = ""
    @State private var selectedLoader: ImageLoaderType = .kingfisher
    
    var body: some View {
        NavigationStack {
            ImagesView(pageInfo: $pageInfo, loaderType: selectedLoader)
                .overlay(alignment: .bottom, content: {
                    Text(pageInfo)
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .frame(width: 250, height: 50)
                        .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)), in: .rect(cornerRadius: 8))
                        .padding()
                })
                .navigationTitle("ImageAsync")
        }
    }
}

#Preview {
    HomeView()
}
