//
//  ImageLoaderView.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-09.
//

import SwiftUI
import Kingfisher

enum ImageLoaderType: String, CaseIterable {
    case kingfisher = "Kingfisher"
}

struct ImageLoaderView: View {
    var imageUrl: URL
    var loaderType: ImageLoaderType
    let size: CGSize
    
    var body: some View {
        /// Kingfisher: Great for SwiftUI and if you need extensive customization options, such as transformations.
        /// https://github.com/onevcat/Kingfisher
        KFImage(imageUrl)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.width)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    VStack {
        if let validUrl = URL(string: "https://picsum.photos/256") {
            ImageLoaderView(imageUrl: validUrl, loaderType: .kingfisher, size: CGSize(width: 100, height: 100))
        } else {
            Text("Invalid URL")
        }
    }
}
