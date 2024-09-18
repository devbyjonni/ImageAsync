
import SwiftUI
import Kingfisher

struct PhotoLoaderView: View {
    let photo: PicsumPhoto
    
    var body: some View {
        KFImage(photo.photoURL)
            .resizable()
            .fade(duration: 0.2)
            .cancelOnDisappear(true)
            .scaledToFill()
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
