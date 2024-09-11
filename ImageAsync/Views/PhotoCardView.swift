//
//  PhotoCardView.swift
//  ImageAsync
//
//  Created by Jonni Akesson on 2024-09-09.
//

import SwiftUI

struct PhotoCardView: View {
    var picsumPhoto: PicsumPhoto
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            if let validUrl = picsumPhoto.photoURL {
                PhotoLoaderView(photoUrl: validUrl)
            } else {
                Text("No photo available")
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
            
            Text(picsumPhoto.author)
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
