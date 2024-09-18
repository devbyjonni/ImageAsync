
import SwiftUI

struct PhotoCardView<ViewModelType: ViewModel>: View {
    @ObservedObject var viewModel: ViewModelType
    let photo: PicsumPhoto
    
    @State private var isAnimating = false
    
    var body: some View {
        HStack(alignment: .top) {
            PhotoLoaderView(photo: photo)
            VStack(alignment: .leading) {
                Text(photo.author)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text(photo.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: viewModel.isFavorite(photo: photo) ? "heart.fill" : "heart")
                .foregroundStyle(viewModel.isFavorite(photo: photo) ? .red : .gray)
                .font(.body)
                .padding()
                .scaleEffect(isAnimating ? 3 : 1.0)  // Scale animation
                .opacity(isAnimating ? 0.5 : 1.0)     // Fade animation
                .animation(.easeInOut(duration: 0.3), value: isAnimating)
            
        }
        .background()
        .padding(5)
        .onTapGesture {
            withAnimation {
                viewModel.toggleFavorite(photo: photo)
                // Trigger the animation based on favorite state
                isAnimating.toggle()
            }
        }
        .onChange(of: viewModel.isFavorite(photo: photo)) { _, _ in
            // Toggle animation when the favorite state changes
            withAnimation {
                isAnimating.toggle()
            }
        }
        .onAppear {
            if photo.id == viewModel.photos.last?.id && !viewModel.isShowingFavorites {
                viewModel.loadData()
            }
        }
    }
}

