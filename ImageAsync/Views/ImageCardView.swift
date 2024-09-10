//
//  ImageCardView.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-09.
//

import SwiftUI

struct ImageCardView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var imageModel: ImageModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            if let validUrl = imageModel.imageURL {
                ImageLoaderView(imageUrl: validUrl)
            } else {
                Text("No image available")
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
            
            Text(imageModel.author)
                .font(.title)
                .textScale(UIDevice.current.userInterfaceIdiom == .pad  ? .default : .secondary)
                .foregroundStyle(.gray)
                .lineLimit(1)
        })
    }
}

#Preview {
    HomeView()
}
