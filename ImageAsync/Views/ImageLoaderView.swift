//
//  ImageLoaderView.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-09.
//

import SwiftUI
import Kingfisher

/// Kingfisher: Great for SwiftUI and if you need extensive customization options, such as transformations.
/// https://github.com/onevcat/Kingfisher
struct ImageLoaderView: View {
    var imageUrl: URL
    let size: CGSize
    
    var body: some View {
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
            ImageLoaderView(imageUrl: validUrl, size: CGSize(width: 100, height: 100))
        } else {
            Text("Invalid URL")
        }
    }
}
