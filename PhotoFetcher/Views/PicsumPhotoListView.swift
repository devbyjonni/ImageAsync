
import SwiftUI

struct PicsumPhotoListView: View {
    @StateObject var viewModel: PicsumPhotoListViewModel
    private let topId: String = "TOP_ID"
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List(viewModel.photos) { photo in
                    PicsumPhotoCardView(viewModel: viewModel, photo: photo)
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
                    PicsumPhotoFavoriteToggleButton(
                               isFavorite: viewModel.isShowingFavorites,
                               toggleAction: { viewModel.toggleFavorites() }
                           )
                }
            }
            .alert(item: $viewModel.viewModelError) { error in
                PicsumPhotoAlertView.alert(error: error) {
                    viewModel.loadData()
                }
            }
        }
    }
}

