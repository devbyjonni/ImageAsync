
import SwiftUI

struct PhotosListView: View {
    @StateObject var viewModel: PhotosListViewModel
    private let topId: String = "TOP_ID"
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List(viewModel.photos) { photo in
                    PhotoCardView(viewModel: viewModel, photo: photo)
                        .id(topId)
                        .padding(.bottom, 5)
                }
                .listStyle(.plain)
                .navigationTitle("ListView")
                .onAppear {
                    proxy.scrollTo(topId)
                }
            }
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
