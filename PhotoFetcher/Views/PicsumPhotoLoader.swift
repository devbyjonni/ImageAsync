
import SwiftUI
import Kingfisher

struct PicsumPhotoLoader: View {
    let photo: PicsumPhoto
    
    var body: some View {
        KFImage(photo.photoURL)
            .resizable()
            // .cacheMemoryOnly(true) // Cache in memory only for smoother scrolling
            .fade(duration: 0.2)
            .cancelOnDisappear(true) // Cancel loading when off-screen
            .scaledToFill()
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

