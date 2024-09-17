
import Foundation

@MainActor
protocol ViewModel: ObservableObject {
    init(dependency: DependencyContainer)
    var photos: [PicsumPhoto] { get set }
    var isShowingFavorites: Bool { get set }
    var viewModelError: ViewModelError? { get set }
    func loadData()
    func isFavorite(photo: PicsumPhoto) -> Bool
    func toggleFavorite(photo: PicsumPhoto)
    func toggleFavorites()
}

