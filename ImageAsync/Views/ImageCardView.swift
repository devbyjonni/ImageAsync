//
//  ImageCardView.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-09.
//

import SwiftUI

struct ImageCardView: View {
    var imageModel: ImageModel
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            VStack(alignment: .leading, spacing: 10, content: {
                if let validUrl = imageModel.imageURL {
                    ImageLoaderView(imageUrl: validUrl, size: size)
                } else {
                    Text("No image available")
                        .foregroundStyle(.gray)
                        .font(.caption)
                }
                Text(imageModel.author)
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            })
        }
        .frame(height: 200)
    }
}

#Preview {
    HomeView()
}
