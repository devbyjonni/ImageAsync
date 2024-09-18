
import SwiftUI

struct PhotosGridView: View {
    @StateObject var viewModel: PhotosGridViewModel
    
    private let topId: String = "TOP_ID"
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1)
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    Color.clear.frame(height: 0).id(topId)
                    LazyVGrid(columns: columns, alignment: .leading) {
                        ForEach(viewModel.photos) { photo in
                            PhotoCardView(viewModel: viewModel, photo: photo)
                        }
                    }
                }
                .onAppear {
                    proxy.scrollTo(topId)
                }
            }
            .padding(.horizontal)
            .navigationTitle("GridView")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    FavoriteToggleButton(
                               isFavorite: viewModel.isShowingFavorites,
                               toggleAction: { viewModel.toggleFavorites() }
                           )
                }
            }
            .alert(item: $viewModel.viewModelError) { error in
                AlertView.alert(error: error) {
                   viewModel.loadData()
                }
            }
        }
    }
}
