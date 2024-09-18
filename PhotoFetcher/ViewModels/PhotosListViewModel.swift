
import Foundation

class PhotosListViewModel: BaseViewModel {
    
    required init(dependency: DependencyContainer) {
        LogMessages.viewModelInit(name: "PhotosListViewModel", functionName: #function)
        super.init(dependency: dependency)
    }
}
